//
//  Copyright © zzmasoud (github.com/zzmasoud).
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
    
    required public init?(start: Date, end: Date) {
        guard start < end else { return nil }
        self.start = start
        self.end = end
    }
    
    public var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
}

extension ZZSItem: CustomStringConvertible {
    public var description: String {
        return "\(start) .... \(end)"
    }
}
