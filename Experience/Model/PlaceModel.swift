//
//  Building.swift
//  Exploration Challenge
//
//  Created by Hafizhuddin Hanif on 08/05/25.
//

import Foundation
import MapKit
import SwiftUI

struct Place: Identifiable, Codable {
    let id: Int
    var name: String
    var desc: String
    var isFavorite: Bool
    var address: String
    var tags: [String]
    var imageName: String
    let buildingID: Int

    var image: Image {
        Image(imageName)
    }
    
}


