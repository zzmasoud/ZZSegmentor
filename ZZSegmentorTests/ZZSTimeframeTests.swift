//
//  ZZSTimeframeTests.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 9/15/22.
//

import XCTest
import ZZSegmentor

class ZZSTimeframe: Timeframe {
    var start: Date
    var end: Date
    var items: [ZZSegmentor.DateItem]
    
    required init(items: [DateItem], start: Date, end: Date) {
        self.items = items
        self.start = start
        self.end = end
    }
    
    func update(start: Date, end: Date) {
        
    }
}

final class ZZSTimeframeTests: XCTestCase {

}
