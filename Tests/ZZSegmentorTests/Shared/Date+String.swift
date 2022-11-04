//
//  Date+String.swift
//  ZZSegmentorTests
//
//  Created by Masoud Sheikh Hosseini on 10/31/22.
//

import Foundation

extension Date {
    init(_ str: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: str)!
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}
