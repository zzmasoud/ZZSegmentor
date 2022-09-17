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
