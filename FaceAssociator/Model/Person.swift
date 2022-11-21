//
//  Person.swift
//  FaceAssociator
//
//  Created by Nick on 2022-11-20.
//

import Foundation
import UIKit

struct Person: Codable, Identifiable, Comparable {
    var id: UUID
    var name: String
    var image: UIImage?
    
    enum CodingKeys: CodingKey {
        case id, name
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}
