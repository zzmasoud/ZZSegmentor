//
//  ZZSegment.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 10/20/22.
//

import XCTest
import ZZSegmentor

enum DateUnit {
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
}

struct ZZSDateUnitShare {
    let date: Date
    let unit: DateUnit
    let duration: TimeInterval
}

class ZZSegment {
    var currentUnit: DateUnit
    private lazy var cal = Calendar.current
    
    init(unit: DateUnit = .hourly) {
        self.currentUnit = unit
    }
    
    func getSegment(of item: DateItem) -> [ZZSDateUnitShare] {
        // it should first group the item units by the currentUnit
        return []
    }
    
    func group(by unit: DateUnit, start: Date, end: Date) -> [Date] {
        let component = unit.toCalendarComponent
        var array: [Date] = [start]
        var tempDate = start
        while !cal.isDate(tempDate, equalTo:end, toGranularity: component), tempDate < end {
            tempDate = cal.date(byAdding: component, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
}

final class ZZSegmentTests: XCTestCase {
    func test_groupBy_returnGroupedDatesForAnItem() {
        let start = Date().addingTimeInterval(-1.hours)
        let end = Date().addingTimeInterval(3.hours)
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment()
        
        let dates = sut.group(by: .hourly, start: item.start, end: item.end)
        
        XCTAssertEqual(dates.first!.hour, item.start.hour)
        XCTAssertEqual(dates.last!.hour, item.end.hour)
    }
}

private extension Date {
    var hour: Int { Calendar.current.component(.hour, from: self) }
    var day: Int { Calendar.current.component(.day, from: self) }
    var month: Int { Calendar.current.component(.month, from: self) }

}
