//
//  Copyright © zzmasoud (github.com/zzmasoud).
//

import Foundation

public class ZZSegmentor {
    private struct Share: DateUnitShare {
        var key: Int
        var value: TimeInterval
    }
    
    private let timeframe: Timeframe
    private let segment: Segment
    private var items: [DateItem]
    
    public init(items: [DateItem], start: Date, end: Date) {
        self.timeframe = ZZSTimeframe(items: items, start: start, end: end)
        self.segment = ZZSegment()
        self.items = items
    }
    
    public init(timeframe: Timeframe, segment: ZZSegment = .init()) {
        self.timeframe = timeframe
        self.items = timeframe.items
        self.segment = segment
    }
    
    public convenience init(start: Date, end: Date) {
        self.init(items: [], start: start, end: end)
    }
    
    public func updateBounds(start: Date, end: Date) {
        self.timeframe.update(start: start, end: end)
    }
    
    public func getSegments(allUnits: Bool = false) -> [DateUnitShare] {
        var dic: [Int: TimeInterval] = [:]
        itemsInTimeframe.forEach { item in
            let segments = segment.getSegments(of: item)
            segments.forEach { segment in
                dic[segment.key] = (dic[segment.key] ?? 0) + segment.value
            }
        }
        
        if allUnits {
            let range = segment.currentUnit.range
            range.forEach { unit in
                dic[unit] = dic[unit] ?? 0
            }
        }
        return dic.map({ Share(key: $0.key, value: $0.value) })
    }
}

extension ZZSegmentor {
    public var start: Date { timeframe.start }
    public var end: Date { timeframe.end }
    public var totalTime: Double { timeframe.items.map(\.duration).reduce(0, +) }
    public var averageTime: Double {
        guard !timeframe.items.isEmpty else { return 0 }
        return totalTime / Double(timeframe.items.count)
    }
    public var itemsInTimeframe: [DateItem] { timeframe.items }
}
