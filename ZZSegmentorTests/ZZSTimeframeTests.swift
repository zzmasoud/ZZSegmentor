//
//  ZZSTimeframeTests.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 9/15/22.
//

import XCTest
import ZZSegmentor

class ZZSTimeframe: Timeframe {
    private(set) var start: Date
    private(set) var end: Date
    private(set) var items: [ZZSegmentor.DateItem]

    required init(items: [DateItem], start: Date, end: Date) {
        self.items = items
        self.start = start
        self.end = end
    }
    
    func update(start: Date, end: Date) {
        
    }

}

final class ZZSTimeframeTests: XCTestCase {

    func test_init_sortItemsAscending() {
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ numberOfItems: Int, start: Date, end: Date) -> ZZSTimeframe {
        var items: [DateItem] = []
        var startDate = start.addingTimeInterval(-2.days)
        for _ in 0..<numberOfItems {
            let begin = startDate.addingTimeInterval(Int.random(in: 1...4).hours + Int.random(in: 0...55).minutes)
            let finish = begin.addingTimeInterval(Int.random(in: 0...4).hours) + Int.random(in: 0...55).minutes
            
            guard let item = ZZSItem(start: begin, end: finish) else { fatalError() }
            items.append(item)
            
            startDate = finish.addingTimeInterval(Int.random(in: 1...3).hours + Int.random(in: 30...55).minutes)
        }
        
        return ZZSTimeframe(items: items, start: start, end: end)
    }
}

private extension Int {
    
    var double: Double {
        return Double(self)
    }
    
    var days: TimeInterval {
        return double * 24 * 60 * 60
    }
    
    var hours: TimeInterval {
        return double * 60 * 60
    }
    
    var minutes: TimeInterval {
        return double * 60
    }
}
