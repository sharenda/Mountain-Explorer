//
//  Mountain.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 21.02.22.
//

import Foundation

struct Mountain: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var name: String
    var continents: String
    var countryies: String
    var highestPoint: String
    var altitude: Double
    var linkToWikipedia: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case continents = "Continent(s)"
        case countryies = "Country/ies"
        case highestPoint = "Highest point"
        case altitude = "Altitude(metres abovesea level)"
    }
}
