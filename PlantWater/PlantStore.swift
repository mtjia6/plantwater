//
//  PlantStore.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/9/26.
//
import Foundation
import SwiftUI
import Combine

class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []
    
    func addPlant(name: String, emoji: String, interval: WateringInterval) {
        let newPlant = Plant(name: name, emoji: emoji, interval: interval)
        plants.append(newPlant)
    }
    
    func deletePlant(id: UUID) {
        plants.removeAll { $0.id == id }
    }
    
    func waterPlant(id: UUID) {
        if let index = plants.firstIndex(where: { $0.id == id }) {
            plants[index].lastWatered = Date()
        }
    }
    
    func editPlant(id: UUID, name: String, emoji: String, interval: WateringInterval) {
        if let index = plants.firstIndex(where: {$0.id == id}) {
            plants[index].name = name
            plants[index].emoji = emoji
            plants[index].interval = interval
        }
    }
    
    init() {
        addPlant(name: "Monstera", emoji: "🌿", interval: .week)
        addPlant(name: "Snake Plant", emoji: "🐍", interval: .month)
        addPlant(name: "Aloe Vera", emoji: "🪴", interval: .twoWeeks)
        
        plants.append(Plant(name: "Basil", emoji: "🌱", interval: .everyDay,
                            lastWatered: Calendar.current.date(byAdding: .day, value: -5, to: Date())!))
    }
    
    
}
