//
//  ZZSegmentor.swift
//  ZZSegmentor
//
//  Created by Masoud Sheikh Hosseini on 9/15/22.
//

import Foundation

public class ZZSegmentor {
    private var timeframe: Timeframe
    private var items: [DateItem]
    
    public init(items: [DateItem], start: Date, end: Date) {
        self.timeframe = ZZSTimeframe(items: items, start: start, end: end)
        self.items = items
    }
    
    public convenience init(timeframe: Timeframe) {
        self.init(items: timeframe.items, start: timeframe.start, end: timeframe.end)
    }
    
    public convenience init(start: Date, end: Date) {
        self.init(items: [], start: start, end: end)
    }
}

extension ZZSegmentor {
    public var start: Date { timeframe.start }
    public var end: Date { timeframe.end }
    public var totalTime: Double { timeframe.items.map(\.duration).reduce(0, +) }
}
