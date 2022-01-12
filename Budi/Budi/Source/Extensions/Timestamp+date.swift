//
//  Timestamp+date.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/12.
//

import Firebase

extension Timestamp {
    
    func convertToahhmm() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self.dateValue())
    }
}
