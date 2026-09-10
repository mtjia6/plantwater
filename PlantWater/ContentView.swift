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

    private var needsWater: [Plant] {
        store.plants.filter { $0.status != .upcoming }
            .sorted { $0.daysUntilDue < $1.daysUntilDue }
    }
    private var upcoming: [Plant] {
        store.plants.filter { $0.status == .upcoming }
            .sorted { $0.daysUntilDue < $1.daysUntilDue }
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12:  return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default:      return "Good night"
        }
    }
    private var dateString: String {
        Date().formatted(.dateTime.weekday(.wide).month(.abbreviated).day()).uppercased()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(dateString)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.warmGray)
                            Text(greeting)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(Color.ink)
                        }
                        Spacer()
                        Button { showingAdd = true } label: {
                            Image(systemName: "plus")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Color.ink)
                                .frame(width: 44, height: 44)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.tileBg))
                        }
                    }

                    if !needsWater.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("NEEDS WATER")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Color.terracotta)
                            ForEach(needsWater) { plant in
                                FeaturedPlantCard(store: store, plant: plant)
                            }
                        }
                    }

                    if !upcoming.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("UPCOMING")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Color.warmGray)
                            VStack(spacing: 0) {
                                ForEach(Array(upcoming.enumerated()), id: \.element.id) { index, plant in
                                    UpcomingRow(store: store, plant: plant)
                                    if index < upcoming.count - 1 { Divider() }
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.appBg.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingAdd) {
                AddPlantView(store: store)
            }
        }
    }
}

struct FeaturedPlantCard: View {
    @ObservedObject var store: PlantStore
    let plant: Plant

    var body: some View {
        VStack(spacing: 16) {
            NavigationLink {
                PlantDetailView(store: store, plantID: plant.id)
            } label: {
                HStack(spacing: 14) {
                    Text(plant.emoji)
                        .font(.system(size: 30))
                        .frame(width: 60, height: 60)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plant.name)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.ink)
                        Text(statusText)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(accent)
                        Text("\(plant.interval.label) · Due \(dueString)")
                            .font(.caption)
                            .foregroundStyle(Color.warmGray)
                    }
                    Spacer()
                }
            }
            .buttonStyle(.plain)

            Button {
                withAnimation(.spring(response: 0.4)) { store.waterPlant(id: plant.id) }
            } label: {
                Text("Mark as watered")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.deepGreen))
                    .foregroundStyle(.white)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 24).fill(accent.opacity(0.15)))
    }

    private var accent: Color {
        plant.status == .overdue ? .red : Color(red: 0.85, green: 0.6, blue: 0.1)
    }
    private var statusText: String {
        plant.status == .overdue ? "\(-plant.daysUntilDue) days overdue" : "Due today"
    }
    private var dueString: String {
        plant.nextDueDate.formatted(.dateTime.month(.abbreviated).day())
    }
}

struct UpcomingRow: View {
    @ObservedObject var store: PlantStore
    let plant: Plant

    var body: some View {
        NavigationLink {
            PlantDetailView(store: store, plantID: plant.id)
        } label: {
            HStack(spacing: 14) {
                Text(plant.emoji)
                    .font(.system(size: 24))
                    .frame(width: 52, height: 52)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.tileBg))
                VStack(alignment: .leading, spacing: 3) {
                    Text(plant.name)
                        .font(.headline)
                        .foregroundStyle(Color.ink)
                    Text("\(plant.interval.label) · \(plant.nextDueDate.formatted(.dateTime.month(.abbreviated).day()))")
                        .font(.subheadline)
                        .foregroundStyle(Color.warmGray)
                }
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(plant.daysUntilDue)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color.deepGreen)
                    Text("days")
                        .font(.caption)
                        .foregroundStyle(Color.warmGray)
                }
            }
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

extension Color {
    static let appBg      = Color(red: 0.96, green: 0.95, blue: 0.91)
    static let deepGreen  = Color(red: 0.18, green: 0.33, blue: 0.25)
    static let sage       = Color(red: 0.84, green: 0.89, blue: 0.83)
    static let terracotta = Color(red: 0.72, green: 0.36, blue: 0.23)
    static let tileBg     = Color(red: 0.91, green: 0.90, blue: 0.86)
    static let ink        = Color(red: 0.11, green: 0.17, blue: 0.13)
    static let warmGray   = Color(red: 0.45, green: 0.46, blue: 0.42)
}

#Preview {
    ContentView()
}
