//
//  CardViewModel.swift
//  FlashCard
//
//  Created by 武林慎太郎 on 2024/02/26.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var timeRemaining = 100
    @Published var isActive = true
    @Published var showingEditScreen = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    

    init() {
        loadData()
    }
    
    func insertCardToBack(card: Card) {
        let index = cards.firstIndex(where: {$0.id == card.id})
        guard let index else { return }
        var clone = cards[index]
        cards.remove(at: index)
        clone.updateID()
        cards.insert(clone, at: 0)

    }
    
    func resetCards() {
        timeRemaining = 100
          isActive = true
          loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func deleteCard(card: Card) {
        let index = cards.firstIndex(where: {$0.id == card.id})
        guard let index else { return }
        cards.remove(at: index)
    }
    
}
