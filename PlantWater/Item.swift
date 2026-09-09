//
//  Item.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/8/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
