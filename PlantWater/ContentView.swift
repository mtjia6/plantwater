//
//  ContentView.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/8/26.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var store = PlantStore()
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.plants.sorted { $0.daysUntilDue < $1.daysUntilDue }) { plant in
                    NavigationLink {
                        PlantDetailView(store: store, plantID: plant.id)
                    } label: {
                        PlantCardView(plant: plant)
                    }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Plants")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddPlantView(store: store)
            }
        }
    }
}

#Preview {
    ContentView()
}
