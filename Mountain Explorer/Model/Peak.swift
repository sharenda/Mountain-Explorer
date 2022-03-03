//
//  Peak.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 22.02.22.
//

import Foundation
import CoreData

public class Peak: NSManagedObject {
    @NSManaged public var title: String
    @NSManaged public var descript: String
    @NSManaged public var elevation: Double
    @NSManaged public var image: Data
    @NSManaged public var location: String
    @NSManaged public var link: String?
    @NSManaged public var coordinates: String?
    @NSManaged public var ratingText: String?
}

extension Peak {
    
    enum Rating: String, CaseIterable {
        case awesome
        case good
        case okay
        case bad
        case terrible
        var image: String {
            switch self {
            case .awesome: return "love"
            case .good: return "cool"
            case .okay: return "happy"
            case .bad: return "sad"
            case .terrible: return "angry"
            }
        }
    }
    
    var rating: Rating? {
        get {
            guard let ratingText = ratingText else {
                return nil
            }
            return Rating(rawValue: ratingText)
        }
        set {
            self.ratingText = newValue?.rawValue
        }
    }
    
}
