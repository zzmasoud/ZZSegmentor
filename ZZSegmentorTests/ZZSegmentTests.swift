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
    
    func getSegments(of item: DateItem) -> [ZZSDateUnitShare] {
        let dates = group(by: currentUnit, start: item.start, end: item.end)
        
        if dates.count == 1 {
            let date = dates[0]
            let dateInterval = cal.dateInterval(of: currentUnit.toCalendarComponent, for: date)!
            let share = item.duration * 100 / dateInterval.duration
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
                }
                else if index == dates.count-1 {
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
    
    func test_getSegments_returnSingleHourlyShareForItemInLessThanOneHour() {
        let start = Calendar.current.startOfDay(for: Date())
        let end = start.addingTimeInterval(45.minutes)
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment()
        
        let segments = sut.getSegments(of: item)
        
        XCTAssert(segments.count == 1)
        XCTAssert(segments.first!.duration == 45.minutes)
        XCTAssert(segments.first!.date == start)
    }
    
    func test_getSegments_returnSingleDailyShareForItemInLessThanOneDay() {
        let start = Calendar.current.startOfDay(for: Date())
        let end = start.addingTimeInterval(21.hours)
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment(unit: .daily)
        
        let segments = sut.getSegments(of: item)
        
        XCTAssert(segments.count == 1)
        XCTAssert(segments.first!.duration == 21.hours)
        XCTAssert(segments.first!.date == start)
    }
    
    func test_getSegments_returnSingleDailyShareForItemInLessThanOneMonth() {
        let start = Calendar.current.startOfDay(for: Date()).startOfMonth
        let end = start.addingTimeInterval(21.days)
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment(unit: .monthly)
        
        let segments = sut.getSegments(of: item)
        
        XCTAssert(segments.count == 1)
        XCTAssert(segments.first!.duration == 21.days)
        XCTAssert(segments.first!.date == start)
    }
    
    func test_getSegments_returnTwoHourlySharesForItemsInPartialBounds() {
        let start = Calendar.current.startOfDay(for: Date()).addingTimeInterval(55.minutes)
        let end = Calendar.current.startOfDay(for: Date()).addingTimeInterval(1.hours).addingTimeInterval(45.minutes)
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment()
        
        let segments = sut.getSegments(of: item)
        
        XCTAssert(segments.count == 2)
        XCTAssert(segments.first!.duration == 5.minutes)
        XCTAssert(segments.first!.date == start)
        XCTAssert(segments.last!.duration == 45.minutes)
        XCTAssert(segments.last!.date == end)
    }
    
    func test_getSegments_returnTwoDailySharesForItemsInPartialBounds() {
        let start = Calendar.current.startOfDay(for: Date()).addingTimeInterval(21.hours)
        let end = Calendar.current.startOfDay(for: Date()).addingTimeInterval(1.days).addingTimeInterval(12.hours)
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment(unit: .daily)
        
        let segments = sut.getSegments(of: item)
        
        XCTAssert(segments.count == 2)
        XCTAssert(segments.first!.duration == 3.hours)
        XCTAssert(segments.first!.date == start)
        XCTAssert(segments.last!.duration == 12.hours)
        XCTAssert(segments.last!.date == end)
    }
    
    func test_getSegments_returnTwoMonthlySharesForItemsInPartialBounds() {
        let start = Date().startOfMonth.addingTimeInterval(5.days)
        let end = start.endOfMonth.addingTimeInterval(1.days).addingTimeInterval(10.days)
        
        let timeIntervalFromStartToEndOfMonth = Calendar.current.dateInterval(of: .month, for: start)!.end.timeIntervalSince1970 - start.timeIntervalSince1970
        
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment(unit: .monthly)
        
        let segments = sut.getSegments(of: item)
        
        XCTAssert(segments.count == 2)
        XCTAssert(segments.first!.duration == timeIntervalFromStartToEndOfMonth)
        XCTAssert(segments.first!.date == start)
        XCTAssert(segments.last!.duration == 10.days)
        XCTAssert(segments.last!.date == end)
    }
    
    func test_getSegments_returnMultipleHourlySharesForItemsInPartialBounds() {
        let start = Calendar.current.startOfDay(for: Date()).addingTimeInterval(55.minutes)
        let end = Calendar.current.startOfDay(for: Date()).addingTimeInterval(7.hours).addingTimeInterval(45.minutes)
        let item: DateItem = ZZSItem(start: start, end: end)!
        let sut = ZZSegment()
        
        let segments = sut.getSegments(of: item)
        
        XCTAssert(segments.count == 8)
        XCTAssert(segments[0].duration == 5.minutes)
        XCTAssert(segments[0].date == start)
        XCTAssert(segments[1].duration == 1.hours)
        XCTAssert(segments[2].duration == 1.hours)
        XCTAssert(segments[3].duration == 1.hours)
        XCTAssert(segments[4].duration == 1.hours)
        XCTAssert(segments[5].duration == 1.hours)
        XCTAssert(segments[6].duration == 1.hours)
        XCTAssert(segments[7].duration == 45.minutes)
        XCTAssert(segments[7].date == end)
    }
}

private extension Date {
    var hour: Int { Calendar.current.component(.hour, from: self) }
    var day: Int { Calendar.current.component(.day, from: self) }
    var month: Int { Calendar.current.component(.month, from: self) }
    var startOfMonth: Date { Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))! }
    var endOfMonth: Date { Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)! }

}
