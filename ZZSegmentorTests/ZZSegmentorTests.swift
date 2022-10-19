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
    
    func test_totalTime_deliversSumOfDurationsInTheTimeframe() {
        let (sut, timeframe) = makeSUT()
        
        let sum = timeframe.items.map(\.duration).reduce(0, +)
        
        XCTAssert(sut.totalTime == sum)
    }
    
    func test_averageTime_deliversZeroForNoItems() {
        let (sut, timeframe) = makeSUT(0)
        let sum = timeframe.items.map(\.duration).reduce(0, +)
            
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
}
