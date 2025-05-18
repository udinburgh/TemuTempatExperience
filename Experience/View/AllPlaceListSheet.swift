import SwiftUI

struct AllPlacesListSheet: View {
    @Binding var detent: PresentationDetent
    let places: [Place]
    let buildings: [Building]
    
    var body: some View {
        NavigationView {
            VStack {
                if places.isEmpty {
                    Text("No places available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(places) { place in
                        NavigationLink(destination: PlaceDetailView(place: place, places: places, buildings: buildings)) {
                            HStack {
                                Image(place.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(place.name)
                                        .font(.headline)
                                    Text(buildingName(for: place.buildingID))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    HStack {
                                        ForEach(place.tags.prefix(2), id: \.self) { tag in
                                            Text("#\(tag)")
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.1))
                                                .clipShape(Capsule())

                                        }
                                    }
                                    HStack {
                                        if place.tags.count > 2 {
                                            Text("+\(place.tags.count - 2) more")
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.1))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                                .padding(.leading)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("All Places")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.fraction(0.2), .fraction(0.85)], selection: $detent)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
    }
    
    private func buildingName(for id: Int) -> String {
        buildings.first(where: { $0.id == id })?.name ?? "Unknown Building"
    }
}


struct AllPlacesListSheet_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var detent: PresentationDetent = .fraction(0.8)
        
        let dummyPlaces: [Place] = [
            Place(
                id: 1,
                name: "Perpustakaan Pusat",
                desc: "Perpustakaan dengan koleksi buku lengkap.",
                isFavorite: true,
                address: "Jl. Pendidikan No.1",
                tags: ["Edukasi", "Tenang"],
                imageName: "library_image",
                buildingID: 101
            ),
            Place(
                id: 2,
                name: "Kantin Bersama",
                desc: "Tempat makan mahasiswa dengan berbagai pilihan.",
                isFavorite: false,
                address: "Jl. Makan No.2",
                tags: ["Makananawdsadawdasd", "Ramai", "Makanan", "Ramai"],
                imageName: "canteen_image",
                buildingID: 102
            )
        ]
        
        let dummyBuildings: [Building] = [
            Building(id: 101, name: "Gedung A", latitude: -6.2, longitude: 106.8),
            Building(id: 102, name: "Gedung B", latitude: -6.3, longitude: 106.7)
        ]
        
        var body: some View {
            AllPlacesListSheet(detent: $detent, places: dummyPlaces, buildings: dummyBuildings)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
