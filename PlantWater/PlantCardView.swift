//
//  PlantCardView.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/9/26.
//

import SwiftUI

struct PlantCardView: View {
    let plant: Plant

    var body: some View {
        HStack(spacing: 14) {
            Text(plant.emoji)
                .font(.system(size: 26))
                .frame(width: 48, height: 48)
                .background(Color(.systemBackground))
                .clipShape(Circle())
                .overlay(Circle().stroke(accent.opacity(0.25), lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(plant.name)
                    .font(.headline)
                Label(plant.interval.label, systemImage: "drop.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .labelStyle(.titleAndIcon)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(statusText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(accent)
                Text(plant.nextDueDate, format: .dateTime.month().day())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(accent.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(accent.opacity(0.15), lineWidth: 1)
        )
    }

    private var statusText: String {
        switch plant.status {
        case .overdue:  return "\(-plant.daysUntilDue)d overdue"
        case .dueToday: return "Due today"
        case .upcoming: return "in \(plant.daysUntilDue)d"
        }
    }

    private var accent: Color {
        switch plant.status {
        case .overdue:  return .red
        case .dueToday: return .orange
        case .upcoming: return .green
        }
    }
}
