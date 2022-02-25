//
//  DataManager.swift
//  FlashZilla
//
//  Created by Dante Cesa on 2/24/22.
//

import Foundation

struct DataManager {
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedCards")
    
    static func loadCards() -> [Card] {
        if let data = try? Data(contentsOf: savePath) {
            if let decodedCards = try? JSONDecoder().decode([Card].self, from: data) {
                let cards = decodedCards
                return cards
            }
        }
        return []
    }
    
    static func saveCards(_ cards: [Card]) {
        if let data = try? JSONEncoder().encode(cards) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}
