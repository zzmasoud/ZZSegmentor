//
//  Int+TimeInterval.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 10/19/22.
//

import Foundation

extension Int {
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
