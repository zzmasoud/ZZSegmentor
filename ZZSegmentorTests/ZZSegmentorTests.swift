//
//  ZZSegmentorTests.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 10/9/22.
//

import XCTest
import ZZSegmentor

final class ZZSegmentorTests: XCTestCase {
    
    func test_init_deliverStartAndEndDates() {
        let start = Date().addingTimeInterval(-1)
        let end = Date().addingTimeInterval(1)
        
        let sut = ZZSegmentor(items: [], start: start, end: end)
        
        XCTAssert(sut.start == start)
        XCTAssert(sut.end == end)
    }
    
    func test_initByTimeFrame_deliversStartAndEndDates() {
        let start = Date().addingTimeInterval(-1)
        let end = Date().addingTimeInterval(1)
        let timeframe = makeTimeframe(start: start, end: end)
        
        let sut = ZZSegmentor(timeframe: timeframe)
        
        XCTAssert(sut.start == start)
        XCTAssert(sut.end == end)
    }
    
    func test_initByDates_deliversEmptyItems() {
        let start = Date().addingTimeInterval(-1)
        let end = Date().addingTimeInterval(1)
        
        let sut = ZZSegmentor(start: start, end: end)
        
        XCTAssert(sut.itemsInTimeframe.isEmpty)
        XCTAssert(sut.start == start)
        XCTAssert(sut.end == end)
    }
    
    func test_totalTime_deliversSumOfDurationsInTheTimeframe() {
        let (sut, timeframe) = makeSUT()
        
        let sum = timeframe.items.map(\.duration).reduce(0, +)
        
        XCTAssert(sut.totalTime == sum)
    }
    
    func test_averageTime_deliversZeroForNoItems() {
        let (sut, _) = makeSUT(0)
            
        XCTAssert(sut.averageTime == 0)
    }
    
    func test_averageTime_deliversAverageDurationsInTheTimeframe() {
        let (sut, timeframe) = makeSUT()
        let sum = timeframe.items.map(\.duration).reduce(0, +)
                        
        XCTAssertEqual(sut.averageTime * Double(timeframe.items.count), sum)
    }
    
    func test_updateBounds_changeBoundsOfTimeframe() {
        let (sut, timeframe) = makeSUT()
        let newStart = Date().addingTimeInterval(-8.hours)
        let newEnd = Date().addingTimeInterval(8.hours)
        
        sut.updateBounds(start: newStart, end: newEnd)
        
        XCTAssertEqual(sut.start, timeframe.start)
        XCTAssertEqual(sut.end, timeframe.end)
    }
    
    func test_itemsInTimeframe_deliverItemsFromTimeframe() {
        let (sut, timeframe) = makeSUT()
        let timeframeItems = timeframe.items
        
        let items = sut.itemsInTimeframe
        
        XCTAssertEqual(items.count, timeframeItems.count)
        XCTAssertEqual(items.first!.start, timeframeItems.first!.start)
        XCTAssertEqual(items.last!.start, timeframeItems.last!.start)
    }
    
    func test_getSegments_deliverSingleHourlyShareForItemsInLessThanOneHourBounds() {
        let items: [DateItem] = [
            ZZSItem(start: Date("2022-10-31 17:00"), end: Date("2022-10-31 17:10"))!,
            ZZSItem(start: Date("2022-10-31 17:20"), end: Date("2022-10-31 17:40"))!,
            ZZSItem(start: Date("2022-10-31 17:45"), end: Date("2022-10-31 17:59"))!,
        ]
        let sut = makeSUT(items: items, segmentUnit: .hourly)
        
        let segments = sut.getSegments()
        
        XCTAssert(segments.count == 1)
        XCTAssertEqual(segments[0].value, items.map(\.duration).reduce(0, +))
    }
    
    func test_getSegments_deliverSingleDailyShareForItemsInLessThanOneDayBounds() {
        let items: [DateItem] = [
            ZZSItem(start: Date("2022-10-31 10:00"), end: Date("2022-10-31 14:10"))!,
            ZZSItem(start: Date("2022-10-31 19:20"), end: Date("2022-10-31 21:40"))!,
            ZZSItem(start: Date("2022-10-31 22:45"), end: Date("2022-10-31 23:59"))!,
        ]
        let sut = makeSUT(items: items, segmentUnit: .daily)
        
        let segments = sut.getSegments()
        
        XCTAssert(segments.count == 1)
        XCTAssertEqual(segments[0].key, 31)
        XCTAssertEqual(segments[0].value, items.map(\.duration).reduce(0, +))
    }
    
    func test_getSegmentWithAllUnits_deliverAllHourlySharesForItems() {
        let items: [DateItem] = [
            ZZSItem(start: Date("2022-10-31 10:00"), end: Date("2022-10-31 14:10"))!,
            ZZSItem(start: Date("2022-10-31 19:20"), end: Date("2022-10-31 21:40"))!,
            ZZSItem(start: Date("2022-10-31 22:45"), end: Date("2022-10-31 23:59"))!,
        ]
        let sut = makeSUT(items: items, segmentUnit: .hourly)
        
        let segments = sut.getSegments(allUnits: true)

        XCTAssert(segments.count == 24)
        XCTAssert(segments.first(where: {$0.key == 0})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 4})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 8})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 10})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 14})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 16})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 18})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 20})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 22})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 23})!.value != 0)
    }
    
    func test_getSegmentsWithAllUnits_deliverAllDailySharesForItems() {
        let items: [DateItem] = [
            ZZSItem(start: Date("2022-11-2 10:00"), end: Date("2022-11-2 14:10"))!,
            ZZSItem(start: Date("2022-11-8 19:20"), end: Date("2022-11-8 21:40"))!,
            ZZSItem(start: Date("2022-11-12 22:45"), end: Date("2022-11-12 23:59"))!,
        ]
        let sut = makeSUT(items: items, segmentUnit: .daily)
        
        let segments = sut.getSegments(allUnits: true)

        XCTAssert(segments.count == 30)
        XCTAssert(segments.first(where: {$0.key == 1})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 2})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 5})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 8})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 10})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 12})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 13})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 18})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 20})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 25})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 28})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 30})!.value == 0)
    }
    
    func test_getSegmentsWithAllUnits_deliverAllMonthlySharesForItems() {
        let items: [DateItem] = [
            ZZSItem(start: Date("2022-1-2 10:00"), end: Date("2022-1-2 14:10"))!,
            ZZSItem(start: Date("2022-8-8 19:20"), end: Date("2022-8-8 21:40"))!,
            ZZSItem(start: Date("2022-12-12 22:45"), end: Date("2022-12-12 23:59"))!,
        ]
        let sut = makeSUT(items: items, segmentUnit: .monthly)
        
        let segments = sut.getSegments(allUnits: true)

        XCTAssert(segments.count == 12)
        XCTAssert(segments.first(where: {$0.key == 1})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 2})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 3})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 8})!.value != 0)
        XCTAssert(segments.first(where: {$0.key == 9})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 10})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 11})!.value == 0)
        XCTAssert(segments.first(where: {$0.key == 12})!.value != 0)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ numberOfItems: Int = 10, start: Date = Date().addingTimeInterval(-2.days), end: Date = Date().addingTimeInterval(2.days)) -> (ZZSegmentor, Timeframe) {
        let timeframe = makeTimeframe(numberOfItems, start: start, end: end)
        return (ZZSegmentor(timeframe: timeframe), timeframe)
    }
    
    private func makeTimeframe(_ numberOfItems: Int = 10, start: Date = Date().addingTimeInterval(-2.days), end: Date = Date().addingTimeInterval(2.days)) -> ZZSTimeframe {
        var items: [DateItem] = []
        var startDate = start.addingTimeInterval(-2.days)
        for _ in 0..<numberOfItems {
            let begin = startDate.addingTimeInterval(Int.random(in: 1...4).hours + Int.random(in: 10...55).minutes)
            let finish = begin.addingTimeInterval(Int.random(in: 0...4).hours) + Int.random(in: 10...55).minutes
            
            guard let item = ZZSItem(start: begin, end: finish) else { fatalError() }
            items.append(item)
            
            startDate = finish.addingTimeInterval(Int.random(in: 1...3).hours + Int.random(in: 30...55).minutes)
        }
        
        return ZZSTimeframe(items: items.shuffled(), start: start, end: end)
    }
    
    private func makeSUT(items: [DateItem], start: Date? = nil, end: Date? = nil, segmentUnit: DateUnit) -> ZZSegmentor {
        let segment = ZZSegment(unit: segmentUnit)
        let timeframe = ZZSTimeframe(items: items, start: start ?? items.first!.start, end: end ?? items.last!.end)
        return ZZSegmentor(timeframe: timeframe, segment: segment)
    }
}
