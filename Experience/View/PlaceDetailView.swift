//
//  PlaceDetailView.swift
//  Experience
//
//  Created by Hafizhuddin Hanif on 12/05/25.
//

import SwiftUI

struct PlaceDetailView: View {
    @State private var detent: PresentationDetent = .fraction(0.8)
    let place: Place
    let places: [Place]
    let buildings: [Building]

    var relatedPlaces: [Place] {
        places.filter { $0.id != place.id && !Set($0.tags).isDisjoint(with: Set(place.tags)) }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(place.name)
                        .font(.largeTitle)
                        .bold()
                    place.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)
                }
                .padding(.bottom)
                
                // Detail dalam kotak bergaya Apple Maps
                
                Text("Detail")
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(place.desc)
                        .font(.body)
                    
                    Divider()
                    
                    Text("Address")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(place.address)
                        .font(.callout)
                    
                    Divider()
                    
                    Text("Tags")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack {
                        ForEach(place.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.callout)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .padding(.bottom)
                
                // Related Places
                if !relatedPlaces.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Similiar Place")
                            .font(.title)
                            .bold()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 12) {
                                ForEach(relatedPlaces) { related in
                                    NavigationLink(destination: PlaceDetailView(place: related, places: places, buildings: buildings)) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            related.image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 90)
                                                .clipped()
                                            
                                            Text(related.name)
                                                .foregroundColor(.primary)
                                                .font(.callout)
                                                .lineLimit(1)
                                            
                                            Text(buildings.first(where: { $0.id == related.buildingID })?.name ?? "Unknown Building")
                                                .foregroundColor(.secondary)
                                                .font(.caption2)
                                                .lineLimit(1)
                                        }
                                        .frame(width: 120, height: 160)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .background(Color(.systemBackground))
                                        .border(Color.gray.opacity(0.2), width: 1)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                    }
                                }
                            }
                        }
                    }
                }

            }
            .padding()
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let samplePlace = Place(
        id: 1,
        name: "Museum Sejarah",
        desc: "Sebuah museum yang menampilkan sejarah kota.",
        isFavorite: false,
        address: "Jl. Merdeka No. 1",
        tags: ["sejarah", "museum", "budaya"],
        imageName: "auntieanne",
        buildingID: 101
    )
    
    let otherPlaces = [
        Place(
            id: 2,
            name: "Galeri Seni",
            desc: "Tempat untuk menikmati seni kontemporer.",
            isFavorite: false,
            address: "Jl. Seni No. 2",
            tags: ["seni", "budaya", "museum"],
            imageName: "auntieanne",
            buildingID: 102
        ),
        Place(
            id: 3,
            name: "Taman Kota",
            desc: "Tempat hijau untuk bersantai.",
            isFavorite: false,
            address: "Jl. Hijau No. 3",
            tags: ["alam", "relaksasi"],
            imageName: "auntieanne",
            buildingID: 103
        )
    ]
    
    let buildings = [
        Building(id: 101, name: "Gedung Sejarah", latitude: -6.2, longitude: 106.8),
        Building(id: 102, name: "Gedung Seni", latitude: -6.21, longitude: 106.81),
        Building(id: 103, name: "Gedung Taman", latitude: -6.22, longitude: 106.82)
    ]
    
    return NavigationView {
        PlaceDetailView(
            place: samplePlace,
            places: [samplePlace] + otherPlaces,
            buildings: buildings
        )
    }
}
