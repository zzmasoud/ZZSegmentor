//
//  ZZSTimeframeTests.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 9/15/22.
//

import XCTest
import ZZSegmentor

final class ZZSTimeframeTests: XCTestCase {

    func test_init_sortItemsAscending() {
        let sut = makeSUT()
        
        let first = sut.items.first!
        let last = sut.items.last!
        
        XCTAssert(first.start < last.start)
    }
    
    func test_update_deliverInBoundsItems() {
        let sut = makeSUT()
        let count = sut.items.count
        let lowerIndex = Int.random(in: 0 ..< count/2)
        let upperIndex = Int.random(in: count/2 ..< count-1)
        
        let newStart = sut.items[lowerIndex].start
        let newEnd = sut.items[upperIndex].end
        sut.update(start: newStart, end: newEnd)
        
        XCTAssert(sut.items.first!.start >= newStart)
        XCTAssert(sut.items.last!.end <= newEnd)
    }
    
    func test_update_deliverNoItemsWhenBeforeBounds() {
        let sut = makeSUT()
        
        let newStart = sut.items.last!.end.addingTimeInterval(1)
        let newEnd = newStart.addingTimeInterval(1.hours)
        sut.update(start: newStart, end: newEnd)
        
        XCTAssert(sut.items.isEmpty)
    }
    
    func test_update_deliverNoItemsWhenAfterBounds() {
        let sut = makeSUT()
        
        let newEnd = sut.items.first!.start.addingTimeInterval(-1)
        let newStart = newEnd.addingTimeInterval(-1.hours)
        sut.update(start: newStart, end: newEnd)
        
        XCTAssert(sut.items.isEmpty)
    }
    
    func test_update_deliverPartialItemOnHeadEdge() {
        let sut = makeSUT()
        let newStart = sut.items.first!.start.addingTimeInterval(-1.hours)
        let newEnd = sut.items.first!.start.addingTimeInterval(10)
        
        sut.update(start: newStart, end: newEnd)

        XCTAssert(sut.items.count == 1)
        XCTAssert(sut.items[0].start >= newStart)
        XCTAssert(sut.items[0].end <= newEnd)
    }
    
    func test_update_deliverPartialItemOnTailEdge() {
        let sut = makeSUT()
        let newStart = sut.items.last!.end.addingTimeInterval(-10)
        let newEnd = newStart.addingTimeInterval(1.hours)
        
        sut.update(start: newStart, end: newEnd)

        XCTAssert(sut.items.count == 1)
        XCTAssert(sut.items[0].start >= newStart)
        XCTAssert(sut.items[0].end <= newEnd)
    }
    
    func test_update_doesNotExtendPartialItemOnHeadEdge() {
        let sut = makeSUT()
        let newStart = sut.items.first!.start.addingTimeInterval(-1.hours)
        let newEnd = sut.items.first!.start.addingTimeInterval(10)
        let itemBeforeChange = sut.items.first!
        
        sut.update(start: newStart, end: newEnd)
        let itemAfterChange = sut.items.first!

        XCTAssert(sut.items.count == 1)
        XCTAssert(sut.items[0].start >= newStart)
        XCTAssert(sut.items[0].end <= newEnd)
        XCTAssert(itemAfterChange.duration < itemBeforeChange.duration)
        XCTAssert(itemAfterChange.start == itemBeforeChange.start)
    }
    
    func test_update_doesNotExtendPartialItemOnTailEdge() {
        let sut = makeSUT()
        let newStart = sut.items.last!.end.addingTimeInterval(-10)
        let newEnd = newStart.addingTimeInterval(1.hours)
        let itemBeforeChange = sut.items.last!
        
        sut.update(start: newStart, end: newEnd)
        let itemAfterChange = sut.items.last!

        XCTAssert(sut.items.count == 1)
        XCTAssert(sut.items[0].start >= newStart)
        XCTAssert(sut.items[0].end <= newEnd)
        XCTAssert(itemAfterChange.duration < itemBeforeChange.duration)
        XCTAssert(itemAfterChange.end == itemBeforeChange.end)
    }
    
    func test_update_deliverInBoundsAndPartialAndSortedItems() {
        let sut = makeSUT()
        let count = sut.items.count
        let lowerIndex = Int.random(in: 0 ..< count/2)
        let upperIndex = Int.random(in: count/2 ..< count-1)
        let totalHours = sut.items.map(\.duration).reduce(0, +)
        let totalCount = sut.items.count
        
        let newStart = sut.items[lowerIndex].start.addingTimeInterval(10)
        let newEnd = sut.items[upperIndex].end.addingTimeInterval(-10)
        sut.update(start: newStart, end: newEnd)
        let newItems = sut.items
        let afterUpdateTotalHours = sut.items.map(\.duration).reduce(0, +)
        let afterUpdateTotalCount = sut.items.count
        
        XCTAssert(newItems.first!.start >= newStart)
        XCTAssert(newItems.last!.end <= newEnd)
        // to check it's sorted
        XCTAssert(newItems.first!.start <= newItems.last!.start)
        // to check it's smaller than before
        XCTAssert(totalHours > afterUpdateTotalHours)
        // to check it's not more than before
        XCTAssert(afterUpdateTotalCount <= totalCount)
    }
    
    func test_update_changeStartAndEnd() {
        let sut = makeSUT()
        let newStart = sut.items.last!.end.addingTimeInterval(-10)
        let newEnd = newStart.addingTimeInterval(1.hours)

        sut.update(start: newStart, end: newEnd)
        
        XCTAssertEqual(sut.start, newStart)
        XCTAssertEqual(sut.end, newEnd)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ numberOfItems: Int = 10, start: Date = Date().addingTimeInterval(-2.days), end: Date = Date().addingTimeInterval(2.days)) -> ZZSTimeframe {
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
