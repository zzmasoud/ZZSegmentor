//
//  ZZSegment.swift
//  ZZSegmentor
//
//  Created by Masoud Sheikh Hosseini on 10/27/22.
//

import Foundation

public enum DateUnit {
    case hourly, daily, monthly
    var toCalendarComponent: Calendar.Component {
        switch self {
        case .hourly:
            return .hour
        case .daily:
            return .day
        case .monthly:
            return .month
        }
    }
    
    var range: Range<Int> {
        switch self {
        case .hourly:
            return 0..<24
        case .daily:
            return 1..<31
        case .monthly:
            return 1..<13
        }
    }
}

public protocol DateUnitShare {
    var key: Int { get }
    var value: TimeInterval { get }
}

public struct ZZSDateUnitShare: DateUnitShare {
    public let date: Date
    public let unit: DateUnit
    public let duration: TimeInterval
    public var value: TimeInterval { return self.duration }
    public var key: Int { return Calendar.current.component(unit.toCalendarComponent, from: date) }
}

public protocol Segment {
    var currentUnit: DateUnit { get }
    func getSegments(of item: DateItem) -> [ZZSDateUnitShare]
}

public class ZZSegment: Segment {
    private lazy var cal = {
        return Calendar.current
    }()
    
    private(set) public var currentUnit: DateUnit
    
    public init(unit: DateUnit = .hourly) {
        self.currentUnit = unit
    }
    
    public func getSegments(of item: DateItem) -> [ZZSDateUnitShare] {
        let dates = group(by: currentUnit, start: item.start, end: item.end)
        
        if dates.count == 1 {
            return [
                ZZSDateUnitShare(date: item.start, unit: currentUnit, duration: item.duration)
            ]
        } else {
            var shares = [ZZSDateUnitShare]()
            for (index, date) in dates.enumerated() {
                if index == 0 {
                    let headDate = date
                    let dateInterval = cal.dateInterval(of: currentUnit.toCalendarComponent, for: headDate)!
                    let inside = DateInterval(start: headDate, end: dateInterval.end)
                    let intersection = dateInterval.intersection(with: inside)!
                    shares.append(ZZSDateUnitShare(date: headDate, unit: currentUnit, duration: intersection.duration))
                } else if index == dates.count-1 {
                    let tailDate = date
                    let dateInterval = cal.dateInterval(of: currentUnit.toCalendarComponent, for: tailDate)!
                    let inside = DateInterval(start: dateInterval.start, end: item.end)
                    let intersection = dateInterval.intersection(with: inside)!
                    shares.append(ZZSDateUnitShare(date: item.end, unit: currentUnit, duration: intersection.duration))
                } else {
                    let dateInterval = cal.dateInterval(of: currentUnit.toCalendarComponent, for: date)!
                    shares.append(ZZSDateUnitShare(date: dateInterval.start, unit: currentUnit, duration: dateInterval.duration))
                }
            }
            return shares
        }
    }
    
    func group(by unit: DateUnit, start: Date, end: Date) -> [Date] {
        let component = unit.toCalendarComponent
        var array: [Date] = [start]
        var tempDate = start
        while !cal.isDate(tempDate, equalTo:end, toGranularity: component), tempDate < end {
            tempDate = cal.date(byAdding: component, value: 1, to: tempDate)!
            array.append(tempDate > end ? end:tempDate)
        }
        return array
    }
}
