//
//  ZZSTimeframe.swift
//  ZZSegmentor
//
//  Created by Masoud Sheikh Hosseini on 10/9/22.
//

import Foundation

public protocol Timeframe {
    var start: Date { get }
    var end: Date { get }
    var items: [DateItem] { get }
    init(items: [DateItem], start: Date, end: Date)
    func update(start: Date, end: Date)
}

final public class ZZSTimeframe: Timeframe {
    public private(set) var start: Date
    public private(set) var end: Date
    public private(set) var items: [ZZSegmentor.DateItem]

    required public init(items: [DateItem], start: Date, end: Date) {
        self.items = items.sorted(by: {$0.start < $1.start})
        self.start = start
        self.end = end
    }
    
    public func update(start: Date, end: Date) {
        var newItems: [ZZSegmentor.DateItem] = []
        var startIndex = 0
        var endIndex = items.count - 1
        var lastItem: ZZSegmentor.DateItem?
        
        while(items[startIndex].end < start && startIndex < endIndex) {
            startIndex += 1
        }
        
        while(items[endIndex].start > end && endIndex > 0) {
            endIndex -= 1
        }
        
        if let index = findEdge(forDate: start),
           let item = ZZSItem(start: start, end: items[index].end) {
            newItems.append(item)
            let nextItemIndex = index + 1
            startIndex = nextItemIndex
        }
        
        // this means it only overlaps last item
        if endIndex > items.count-1 { return self.items = newItems }
        
        if let index = findEdge(forDate: end) {
            lastItem = ZZSItem(start: items[index].start, end: end)
            let prevItemIndex = index - 1
            endIndex = prevItemIndex
        }
        
        // this means it only overlaps first item
        if let lastItem = lastItem, startIndex < 0  { return self.items = [lastItem] }

        
        if endIndex > startIndex {
            newItems.append(contentsOf: items[startIndex...endIndex])
        }
        
        if let last = lastItem {
            newItems.append(last)
        }
        
        self.items = newItems
    }
    
    private func findEdge(forDate date: Date) -> Int? {
        return items.firstIndex(where: {
            return date > $0.start && date < $0.end
        })
    }
}
