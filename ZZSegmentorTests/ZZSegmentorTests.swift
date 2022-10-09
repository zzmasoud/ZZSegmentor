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
        let timeframe = ZZSTimeframe(items: [], start: start, end: end)
        
        let sut = ZZSegmentor(timeframe: timeframe)
        
        XCTAssert(sut.start == start)
        XCTAssert(sut.end == end)

    }
}
