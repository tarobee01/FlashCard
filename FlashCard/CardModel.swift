//
//  CardModel.swift
//  FlashCard
//
//  Created by 武林慎太郎 on 2024/02/25.
//

import Foundation

struct Card: Codable, Identifiable{
    var prompt: String
    var answer: String
    var id = UUID()
    
    mutating func updateID() {
        id.self = UUID()
    }

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
