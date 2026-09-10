//
//  PlantDetailView.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/9/26.
//

import SwiftUI

struct PlantDetailView: View {
    @ObservedObject var store: PlantStore
    let plantID: UUID
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var emoji = "🌿"
    @State private var interval: WateringInterval = .week
    @State private var showDeleteConfirm = false

    private let emojiOptions = ["🌿","🌵","🌱","🪴","🌳","🌸","🍃","🌺","🌻","🎋"]

    private var plant: Plant? {
        store.plants.first { $0.id == plantID }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    if let plant {
                        VStack(spacing: 12) {
                            Text(emoji)
                                .font(.system(size: 60))
                                .frame(width: 104, height: 104)
                                .background(Circle().fill(Color.green.opacity(0.12)))
                            Text(name.isEmpty ? "Unnamed" : name)
                                .font(.title2.weight(.semibold))
                            Text(statusLine(plant))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                        Button {
                            store.waterPlant(id: plantID)
                        } label: {
                            Label("Mark as Watered", systemImage: "drop.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.green))
                                .foregroundStyle(.white)
                        }

                        labeled("NAME") {
                            TextField("Name", text: $name)
                                .textInputAutocapitalization(.words)
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemBackground)))
                        }

                        labeled("EMOJI") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                                ForEach(emojiOptions, id: \.self) { option in
                                    Text(option)
                                        .font(.system(size: 26))
                                        .frame(width: 50, height: 50)
                                        .background(Circle().fill(option == emoji
                                            ? Color.green.opacity(0.2) : Color(.systemBackground)))
                                        .overlay(Circle().stroke(option == emoji ? Color.green : .clear, lineWidth: 2))
                                        .onTapGesture { withAnimation(.spring(response: 0.3)) { emoji = option } }
                                }
                            }
                        }

                        labeled("WATERING SCHEDULE") {
                            VStack(spacing: 10) {
                                ForEach(WateringInterval.allCases, id: \.self) { option in
                                    HStack {
                                        Text(option.label).font(.body.weight(.medium))
                                        Spacer()
                                        if option == interval { Image(systemName: "checkmark.circle.fill") }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .foregroundStyle(option == interval ? Color.green : .primary)
                                    .background(RoundedRectangle(cornerRadius: 14).fill(option == interval
                                        ? Color.green.opacity(0.12) : Color(.systemBackground)))
                                    .onTapGesture { withAnimation(.spring(response: 0.3)) { interval = option } }
                                }
                            }
                        }

                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            Text("Delete Plant")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color(.systemBackground)))
                                .foregroundStyle(.red)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: load)
        .onChange(of: name) { _, _ in saveEdits() }
        .onChange(of: emoji) { _, _ in saveEdits() }
        .onChange(of: interval) { _, _ in saveEdits() }
        .confirmationDialog("Delete this plant?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                store.deletePlant(id: plantID)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    private func load() {
        guard let plant else { return }
        name = plant.name
        emoji = plant.emoji
        interval = plant.interval
    }

    private func saveEdits() {
        store.editPlant(id: plantID, name: name, emoji: emoji, interval: interval)
    }

    private func statusLine(_ plant: Plant) -> String {
        switch plant.status {
        case .overdue:  return "\(-plant.daysUntilDue) days overdue"
        case .dueToday: return "Needs water today"
        case .upcoming: return "Next water in \(plant.daysUntilDue) days"
        }
    }

    @ViewBuilder
    private func labeled<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
