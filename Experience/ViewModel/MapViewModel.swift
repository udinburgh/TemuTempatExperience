//
//  MapViewModel.swift
//  Experience
//
//  Created by Hafizhuddin Hanif on 12/05/25.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var selectedBuilding: Building? = nil
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -6.302370, longitude: 106.652059),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Published var searchText: String = ""
    @Published var selectedTags: Set<String> = []
    
    private var defaults = UserDefaults(suiteName: "com.udinburgh.Experience") ?? .standard
    private var selectedTagFromShortcut: String = ""
    
    private let modelData: ModelData
    
    init(modelData: ModelData) {
        self.modelData = modelData
        if !selectedTagFromShortcut.isEmpty {
            selectedTags = [selectedTagFromShortcut.capitalized]
            // Optional: Kosongkan lagi setelah digunakan
            UserDefaults.standard.removeObject(forKey: "selectedTagFromShortcut")
        }
        loadSelectedTagFromShortcut()
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(userDefaultsDidChange),
                    name: UserDefaults.didChangeNotification,
                    object: defaults
                )
    }
    
    var buildings: [Building] {
        modelData.building
    }
    
    var places: [Place] {
        modelData.place
    }
    
    var allTags: [String] {
        let tags = modelData.place.flatMap { $0.tags }
        return Array(Set(tags)).sorted()
    }
    
    func places(for building: Building) -> [Place] {
        modelData.place.filter { $0.buildingID == building.id }
    }
    
    // MARK: - Filtering Logic
    var filteredAllPlaces: [Place] {
        modelData.place.filter { matchesSearch($0) && matchesTags($0) }
    }
    
    func filteredPlaces(for building: Building) -> [Place] {
        modelData.place.filter { $0.buildingID == building.id && matchesSearch($0) && matchesTags($0) }
    }
    
    func matchesSearch(_ place: Place) -> Bool {
        searchText.isEmpty || place.name.localizedCaseInsensitiveContains(searchText)
    }
    
    func matchesTags(_ place: Place) -> Bool {
        // Cek apakah selectedTags kosong (tidak ada filter tag), jika kosong maka semua tempat diterima
        guard !selectedTags.isEmpty else { return true }
        
        // Pastikan setiap tag pada place mengandung seluruh selectedTags (AND logic)
        return selectedTags.isSubset(of: Set(place.tags))
    }
    
    private func loadSelectedTagFromShortcut() {
            if let savedTag = defaults.string(forKey: "selectedTagFromShortcut") {
                selectedTags = [savedTag.capitalized]
                defaults.removeObject(forKey: "selectedTagFromShortcut")
            }
        }

        @objc private func userDefaultsDidChange(_ notification: Notification) {
            // Ketika UserDefaults berubah, load lagi
            loadSelectedTagFromShortcut()
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
}

