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
}

struct ZZSDateUnitShare {
    let date: Date
    let unit: DateUnit
    let duration: TimeInterval
}

class ZZSegment {
    var currentUnit: DateUnit
    
    init(unit: DateUnit = .hourly) {
        self.currentUnit = unit
    }
}

final class ZZSegmentTests: XCTestCase {
    
}
