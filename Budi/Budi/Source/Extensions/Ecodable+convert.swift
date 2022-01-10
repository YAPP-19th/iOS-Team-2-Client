//
//  Ecodable+convert.swift
//  Budi
//
//  Created by leeesangheee on 2022/01/10.
//

import Foundation

extension Encodable {
    var convertToDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictionary
    }
}
