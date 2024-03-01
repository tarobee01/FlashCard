//
//  ContentView.swift
//  FlashCard
//
//  Created by 武林慎太郎 on 2024/02/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.scenePhase) var scenePhase
    @StateObject var cardVm = CardViewModel()
    
    func returnIndex(card: Card) -> Int?{
        let index = cardVm.cards.firstIndex(where: {$0.id == card.id})
        guard let index else { return nil }
        return index
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Time: \(cardVm.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                Button("Start Again", action: cardVm.resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)

                ZStack {
                    ForEach(cardVm.cards) { card in
                        CardView(card: card, 
                                 insertCardtoBack:
                                    {  cardVm.insertCardToBack(card: card) },
                                 removal:  
                                    {  cardVm.deleteCard(card: card)})
                        .stacked(at: returnIndex(card: card) ?? 0, in: cardVm.cards.count)
                    }
                }
            }
            VStack {
                HStack {
                    Spacer()

                    Button {
                        cardVm.showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }

                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            if accessibilityDifferentiateWithoutColor {
                VStack {
                    Spacer()

                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }

        }
        .sheet(isPresented: $cardVm.showingEditScreen, onDismiss: cardVm.resetCards) {
            EditCardView()
        }
        .onAppear(perform: cardVm.loadData)
        .onReceive(cardVm.timer) { time in
            guard cardVm.isActive == true else {
                return
            }
            if cardVm.timeRemaining > 0 {
                cardVm.timeRemaining -= 1
            }
        }
//        .onChange(of: scenePhase) { newPhase in
//            if newPhase == .active {
//                if cards.isEmpty == false {
//                    isActive = true
//                }
//            } else {
//                isActive = false
//            }
//        }
//        .allowsHitTesting(timeRemaining > 0)
//
// 
    }
}

#Preview {
    ContentView()
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}
