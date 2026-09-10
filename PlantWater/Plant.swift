//
//  Plant.swift
//  PlantWater
//
//  Created by Miguel Tjia on 9/9/26.
//

import Foundation

enum WateringInterval: Int, Codable, CaseIterable, Identifiable {
    case everyDay = 1
    case threeDays = 3
    case week = 7
    case twoWeeks = 14
    case month = 30
    
    var id: Int { rawValue }
    var days: Int { rawValue }
    
    var label: String {
        switch self {
        case .everyDay: return "Every day"
        case .threeDays: return "Every 3 days"
        case .week: return "Every week"
        case .twoWeeks: return "Every 2 weeks"
        case .month: return "Every month"
        }
    }
}

struct Plant: Identifiable, Codable {
    let id = UUID()
    var name: String
    var emoji: String
    var interval: WateringInterval
    var lastWatered: Date
    
    init(name: String, emoji: String, interval: WateringInterval, lastWatered: Date = Date()) {
        self.name = name
        self.emoji = emoji
        self.interval = interval
        self.lastWatered = lastWatered
    }
}

enum PlantStatus {
    case overdue
    case dueToday
    case upcoming
}

extension Plant {
    var nextDueDate: Date {
        Calendar.current.date(byAdding: .day, value: interval.days, to: lastWatered) ?? lastWatered
    }

    var daysUntilDue: Int {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let due = cal.startOfDay(for: nextDueDate)
        return cal.dateComponents([.day], from: today, to: due).day ?? 0
    }

    var status: PlantStatus {
        if daysUntilDue < 0 { return .overdue }
        if daysUntilDue == 0 { return .dueToday }
        return .upcoming
    }
}


