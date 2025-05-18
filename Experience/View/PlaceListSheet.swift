
import SwiftUI

struct PlaceListSheet: View {
    @Binding var detent: PresentationDetent
    @Binding var selectedBuilding: Building?
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
            .navigationTitle(selectedBuilding?.name ?? "All Places") // Judul tetap ada
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            selectedBuilding = nil // Tutup sheet dengan animasi
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("All Places")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.2), .fraction(0.85)], selection: $detent)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
    }
    private func buildingName(for id: Int) -> String {
        buildings.first(where: { $0.id == id })?.name ?? "Unknown Building"
    }
}
