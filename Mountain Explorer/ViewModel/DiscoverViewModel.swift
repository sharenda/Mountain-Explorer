//
//  ViewModel.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 21.02.22.
//

import Foundation

class Response: ObservableObject {
    @Published var results: [Mountain]
    
    init() {
        results = []
    }
    
    @MainActor func loadData() async {
        guard let url = URL(string: "https://sheet2api.com/wiki-api/List_of_mountain_ranges/en/By+size") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode([Mountain].self, from: data) {
                results = decoded
            } else {
                print("Decoding failed!")
            }
        } catch {
            print("Invalid data")
        }
        
        for (n, _) in results.enumerated() {
            results[n].name = results[n].name.replacingOccurrences(of: " (Note 2)", with: "")
            results[n].linkToWikipedia = await getLinkToWikipediaPage(for: results[n]) ?? ""
        }
    }
    
    private func getLinkToWikipediaPage(for mountain: Mountain) async -> String? {
        var link: String = ""
        
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?action=opensearch&search=\(mountain.name.replacingOccurrences(of: " ", with: "+"))&limit=1&namespace=0&format=json") else {
            print("Invalid URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            link = String(decoding: data, as: UTF8.self)
        } catch {
            print("Invalid data")
            return nil
        }
        
        return link.components(separatedBy: ",")[3].filter { $0 != "\"" && $0 != "[" && $0 != "]" }
    }
}
