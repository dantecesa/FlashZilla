//
//  Card.swift
//  FlashZilla
//
//  Created by Dante Cesa on 2/23/22.
//

import Foundation

struct Card: Codable {
    let question: String
    let answer: String
    
    static let example = Card(question: "Who founded ?", answer: "Steve Jobs, Steve Wozniak, & Ronald Wayne")
}
