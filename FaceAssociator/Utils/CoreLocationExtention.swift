//
//  CoreLocationExtention.swift
//  FaceAssociator
//
//  Created by Nick on 2022-11-21.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
