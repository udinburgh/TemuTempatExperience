//
//  PlaceListViewModel.swift
//  Experience
//
//  Created by Hafizhuddin Hanif on 12/05/25.
//

import Foundation

class PlaceListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedTags: Set<String> = []

    private let allPlaces: [Place]

    init(places: [Place]) {
        self.allPlaces = places
    }

    var tags: [String] {
        Array(Set(allPlaces.flatMap { $0.tags })).sorted()
    }

    func places(for building: Building?) -> [Place] {
        allPlaces.filter { place in
            (building == nil || place.buildingID == building!.id) &&
            matchesSearch(place) &&
            matchesTags(place)
        }
    }

    private func matchesSearch(_ place: Place) -> Bool {
        searchText.isEmpty || place.name.localizedCaseInsensitiveContains(searchText)
    }

    private func matchesTags(_ place: Place) -> Bool {
        selectedTags.isEmpty || !selectedTags.isDisjoint(with: place.tags)
    }
}
