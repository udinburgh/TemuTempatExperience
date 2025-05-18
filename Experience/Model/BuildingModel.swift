//
//  Building.swift
//  Exploration
//
//  Created by Hafizhuddin Hanif on 10/05/25.
//

import Foundation
import MapKit

struct Building: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}
