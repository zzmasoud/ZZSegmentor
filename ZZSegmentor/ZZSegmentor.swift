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
