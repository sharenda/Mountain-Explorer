//
//  CountryPickerViewModel.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 23.02.22.
//

import Foundation

class CountryPickerViewModel {
    let countrys: [Country]
    
    init() {
        if let fileURL = Bundle.main.url(forResource: "list-of-country", withExtension: "json") {
            if let fileContents = try? Data(contentsOf: fileURL) {
                if let decoded = try? JSONDecoder().decode([Country].self, from: fileContents) {
                    countrys = decoded.sorted()
                    return
                }
            }
        }
        
        fatalError("error reading list-of-country.json")
    }
}
