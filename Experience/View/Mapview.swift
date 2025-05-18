//
//  Mapview.swift
//  Experience
//
//  Created by Hafizhuddin Hanif on 12/05/25.
//
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var modelData = ModelData()
    @StateObject private var viewModel: MapViewModel
    @State private var showingSheet = true
    @State private var detent: PresentationDetent = .fraction(0.85)
    @FocusState private var isSearchFocused: Bool

    init() {
        let modelData = ModelData()
        _modelData = StateObject(wrappedValue: modelData)
        _viewModel = StateObject(wrappedValue: MapViewModel(modelData: modelData))
    }

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $viewModel.region, annotationItems: modelData.building) { building in
                MapAnnotation(coordinate: building.locationCoordinate) {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.selectedBuilding = building
                            showingSheet = true
                            detent = .fraction(0.85)
                            isSearchFocused = false
                        }
                    }) {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.blue)
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    Text(building.name)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(4)
                }
            }
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 8) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search...", text: $viewModel.searchText)
                        .focused($isSearchFocused)
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation {
                        detent = .fraction(0.85)
                        showingSheet = true
                        isSearchFocused = true
                    }
                }


                // Tag Filters
                // Tag Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // Tombol "All"
                        Button(action: {
                            viewModel.selectedTags.removeAll()
                        }) {
                            Text("All")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(viewModel.selectedTags.isEmpty ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(viewModel.selectedTags.isEmpty ? .white : .primary)
                                .cornerRadius(10)
                        }

                        // Selected tags (ditampilkan dulu setelah "All")
                        ForEach(Array(viewModel.selectedTags), id: \.self) { tag in
                            Button(action: {
                                viewModel.selectedTags.remove(tag)
                            }) {
                                Text(tag)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }

                        // Unselected tags (sisa tag yang belum dipilih)
                        ForEach(viewModel.allTags.filter { !viewModel.selectedTags.contains($0) }, id: \.self) { tag in
                            Button(action: {
                                viewModel.selectedTags.insert(tag)
                            }) {
                                Text(tag)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingSheet) {
            if let selected = viewModel.selectedBuilding {
                PlaceListSheet(
                    detent: $detent,
                    selectedBuilding: $viewModel.selectedBuilding,
                    places: viewModel.filteredPlaces(for: selected),
                    buildings: viewModel.buildings
                )
                .presentationDetents([.fraction(0.15), .fraction(0.85)], selection: $detent)
                .interactiveDismissDisabled()
            } else {
                AllPlacesListSheet(
                    detent: $detent,
                    places: viewModel.filteredAllPlaces,
                    buildings: viewModel.buildings
                )

                .presentationDetents([.fraction(0.15), .fraction(0.85)], selection: $detent)
                .interactiveDismissDisabled()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWrapper()
    }

    struct MapViewWrapper: View {
        var body: some View {
            MapView()
        }
    }
}
