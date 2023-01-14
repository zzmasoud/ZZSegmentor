//
//  Copyright © zzmasoud (github.com/zzmasoud).
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
