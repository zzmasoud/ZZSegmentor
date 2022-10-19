//
//  ZZSegmentor.swift
//  ZZSegmentor
//
//  Created by Masoud Sheikh Hosseini on 9/15/22.
//

import Foundation

public class ZZSegmentor {
    private let timeframe: Timeframe
    private var items: [DateItem]
    
    public init(items: [DateItem], start: Date, end: Date) {
        self.timeframe = ZZSTimeframe(items: items, start: start, end: end)
        self.items = items
    }
    
    public init(timeframe: Timeframe) {
        self.timeframe = timeframe
        self.items = timeframe.items
    }
    
    public convenience init(start: Date, end: Date) {
        self.init(items: [], start: start, end: end)
    }
    
    public func updateBounds(start: Date, end: Date) {
        self.timeframe.update(start: start, end: end)
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
