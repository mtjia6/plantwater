//
//  PlantStore.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/9/26.
//
import Foundation
import SwiftUI

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
    
    func update(_ plant: Plant) {
        if let index = plants.firstIndex(where: {$0.id == plant.id}) {
            plants[index] = plant
        }
    }
    
    
}
