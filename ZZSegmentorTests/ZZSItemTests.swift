//
//  ZZSItemTests.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 9/16/22.
//

import XCTest
import ZZSegmentor

class ZZSItem: ZZSegmentor.DateItem {
    var start: Date
    
    var end: Date
    
    var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
    
    required init?(start: Date, end: Date) {
        guard start < end else { return nil }
        self.start = start
        self.end = end
    }
}

final class ZZSItemTests: XCTestCase {
    
    
}
