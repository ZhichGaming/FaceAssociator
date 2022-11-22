//
//  Person.swift
//  FaceAssociator
//
//  Created by Nick on 2022-11-20.
//

import Foundation
import UIKit
import CoreLocation

struct Person: Codable, Identifiable, Comparable {
    var id: UUID
    var name: String
    var location: Location?
    var image: UIImage?
    
    enum CodingKeys: CodingKey {
        case id, name, location
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}

struct Location: Identifiable, Codable, Equatable {
    let id = UUID()
    var longitude: Double
    var latitude: Double
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: CodingKey {
        case latitude, longitude
    }
}
