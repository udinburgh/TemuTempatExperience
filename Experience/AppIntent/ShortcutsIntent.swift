//
//  FilterPlaceByTagIntent.swift
//  Exploration
//
//  Created by Hafizhuddin Hanif on 16/05/25.
//

import AppIntents

// MARK: - Enum Tag Tempat
enum PlaceTag: String, AppEnum {
    case food, coffee, entertainment

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Tag Tempat"
    }

    static var caseDisplayRepresentations: [PlaceTag: DisplayRepresentation] {
        [
            .food: "Food",
            .coffee: "Coffee",
            .entertainment: "Entertainment"
        ]
    }
}

// MARK: - Intent dengan Pilihan Tag
struct FilterPlaceByTagIntent: AppIntent {
    static var title: LocalizedStringResource = "Lihat Tempat Berdasarkan Tag"
    static var description = IntentDescription("Membuka aplikasi dan memfilter tempat berdasarkan tag pilihan kamu.")
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Tag Tempat")
    var tag: PlaceTag

    @MainActor
    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "com.udinburgh.Experience") ?? .standard
        defaults.set(tag.rawValue, forKey: "selectedTagFromShortcut")
        return .result()
    }
}

// MARK: - Shortcut Langsung untuk Coffee

struct ShowCoffeePlacesIntent: AppIntent {
    static var title: LocalizedStringResource = "Lihat Tempat Coffee"
    static var description = IntentDescription("Buka aplikasi dan filter tag Coffee.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "com.udinburgh.Experience") ?? .standard
        defaults.set("coffee", forKey: "selectedTagFromShortcut")
        try await Task.sleep(nanoseconds: 150_000_000) // delay 0.15 detik
        return .result()
    }
}


// MARK: - Shortcut Builder
struct AppIntentShortcutProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: FilterPlaceByTagIntent(),
            phrases: [
                "Lihat tempat di \(.applicationName)",
                "Eksplorasi di \(.applicationName)",
                "Eksplor tag tempat di \(.applicationName)"
            ],
            shortTitle: "Search by Tags",
            systemImageName: "tag"
        )

        AppShortcut(
            intent: ShowCoffeePlacesIntent(),
            phrases: [
                "Tempat ngopi di \(.applicationName)",
                "Lihat coffee di \(.applicationName)",
                "Eksplor coffee shop di \(.applicationName)",
                "Cari coffee shop di \(.applicationName)"
            ],
            shortTitle: "Coffee Places",
            systemImageName: "cup.and.saucer.fill"
        )
    }
}
