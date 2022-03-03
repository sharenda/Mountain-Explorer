//
//  CountryPicker.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 23.02.22.
//

import SwiftUI

struct CountryPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var location: String
    @State private var searchText = ""
    
    let countryPickerViewModel = CountryPickerViewModel()
    
    var body: some View {
        NavigationView {
            List(searchResults) { country in
                Button("\(country.emoji) \(country.name)") {
                    location = "\(country.emoji) \(country.name)"
                    dismiss()
                }
                .foregroundColor(.primary)
            }
            .searchable(text: $searchText)
            .navigationTitle("Choose location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
    
    var searchResults: [Country] {
        if searchText.isEmpty {
            return countryPickerViewModel.countrys
        } else {
            return countryPickerViewModel.countrys.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct CountryPicker_Previews: PreviewProvider {
    static var previews: some View {
        CountryPicker(location: .constant(""))
    }
}
