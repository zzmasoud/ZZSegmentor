//
//  ZZSItem.swift
//  ZZSegmentor
//
//  Created by Masoud Sheikh Hosseini on 10/9/22.
//

import Foundation

public protocol DateItem {
    var start: Date { get }
    var end: Date { get }
    var duration: TimeInterval { get }
    init?(start: Date, end: Date)
}


final public class ZZSItem: DateItem {
    public private(set) var start: Date
    
    public private(set) var end: Date
    
    public var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
    
    required public init?(start: Date, end: Date) {
        guard start < end else { return nil }
        self.start = start
        self.end = end
    }
}

extension ZZSItem: CustomStringConvertible {
    public var description: String {
        return "\(start) .... \(end)"
    }
}
