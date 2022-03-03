//
//  Country.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 23.02.22.
//

import Foundation

struct Country: Identifiable, Codable, Hashable, Comparable {
    var id = UUID().uuidString
    var name: String
    var code: String
    var emoji: String
    var unicode: String
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "code"
        case emoji = "emoji"
        case unicode = "unicode"
        case image = "image"
    }
    
    static func < (lhs: Country, rhs: Country) -> Bool { lhs.name < rhs.name }
}
