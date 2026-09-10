//
//  AddPlantView.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/9/26.
//
import SwiftUI

struct AddPlantView: View {
    @ObservedObject var store: PlantStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var emoji = "🌿"
    @State private var interval: WateringInterval = .week

    private let emojiOptions = ["🌿","🌵","🌱","🪴","🌳","🌸","🍃","🌺","🌻","🎋"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {

                        VStack(spacing: 12) {
                            Text(emoji)
                                .font(.system(size: 60))
                                .frame(width: 104, height: 104)
                                .background(Circle().fill(Color.green.opacity(0.12)))
                            Text(name.isEmpty ? "New Plant" : name)
                                .font(.title2.weight(.semibold))
                            Text(interval.label)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                        labeled("NAME") {
                            TextField("e.g. Monstera", text: $name)
                                .textInputAutocapitalization(.words)
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(.systemBackground)))
                        }

                        labeled("EMOJI") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5),
                                      spacing: 12) {
                                ForEach(emojiOptions, id: \.self) { option in
                                    Text(option)
                                        .font(.system(size: 26))
                                        .frame(width: 50, height: 50)
                                        .background(Circle().fill(option == emoji
                                            ? Color.green.opacity(0.2)
                                            : Color(.systemBackground)))
                                        .overlay(Circle().stroke(option == emoji
                                            ? Color.green : .clear, lineWidth: 2))
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.3)) { emoji = option }
                                        }
                                }
                            }
                        }

                        labeled("WATERING SCHEDULE") {
                            VStack(spacing: 10) {
                                ForEach(WateringInterval.allCases, id: \.self) { option in
                                    HStack {
                                        Text(option.label)
                                            .font(.body.weight(.medium))
                                        Spacer()
                                        if option == interval {
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .foregroundStyle(option == interval ? Color.green : .primary)
                                    .background(RoundedRectangle(cornerRadius: 14)
                                        .fill(option == interval
                                            ? Color.green.opacity(0.12)
                                            : Color(.systemBackground)))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) { interval = option }
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        store.addPlant(name: name, emoji: emoji, interval: interval)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    @ViewBuilder
    private func labeled<Content: View>(_ title: String,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
