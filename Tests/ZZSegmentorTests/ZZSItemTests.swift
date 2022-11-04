//
//  ZZSItemTests.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 9/16/22.
//

import XCTest
import ZZSegmentor

final class ZZSItemTests: XCTestCase {
    
    func test_init_returnsNilOnWrongDates() {
        let sut = ZZSItem(start: Date(), end: Date().addingTimeInterval(-1))
        
        XCTAssertNil(sut)
    }
    
    func test_duration_returnsTimeIntervalBetweenStartAndEnd() throws {
        guard let sut = ZZSItem(start: Date(), end: Date().addingTimeInterval(12345)) else { throw NSError() }
        let diff: TimeInterval = sut.end.timeIntervalSince1970 - sut.start.timeIntervalSince1970
        
        let duration = sut.duration
        
        XCTAssertEqual(duration, diff)
    }
    
    func test_description_deliversEnoughData() throws {
        guard let sut = ZZSItem(start: Date(), end: Date().addingTimeInterval(12345)) else { throw NSError() }
        
        let description = sut.description
        
        XCTAssert(description.contains(sut.start.description))
        XCTAssert(description.contains(sut.end.description))
    }
    
}
