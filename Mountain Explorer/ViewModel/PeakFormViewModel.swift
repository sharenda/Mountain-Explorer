//
//  PeakFormViewModel.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 23.02.22.
//

import Foundation
import UIKit
import SwiftUI

class PeakFormViewModel: ObservableObject {
    @Published var title: String
    @Published var descript: String
    @Published var elevation: Double?
    @Published var image: UIImage
    @Published var link: String
    @Published var coordinates: String
    @Published var location: String
    
    init(image: UIImage) {
        title = ""
        descript = ""
        elevation = nil
        self.image = image
        link = ""
        coordinates = ""
        location = ""
    }
}
