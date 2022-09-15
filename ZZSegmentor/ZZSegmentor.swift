//
//  ZZSegmentor.swift
//  ZZSegmentor
//
//  Created by Masoud Sheikh Hosseini on 9/15/22.
//

import Foundation

public protocol DateItem {
    var start: Date { get }
    var end: Date { get }
    var duration: TimeInterval { get }
}

public protocol Timeframe {
    var start: Date { get }
    var end: Date { get }
    var items: [DateItem] { get }
    init(start: Date, end: Date)
    func update(start: Date, end: Date)
}
