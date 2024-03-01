//
//  CardView.swift
//  FlashCard
//
//  Created by 武林慎太郎 on 2024/02/25.
//

import SwiftUI

struct CardView: View {
    let card: Card
    @State private var isShowingAnswer = false
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
  
    var insertCardtoBack: (() -> Void)? = nil
    var removal: (() -> Void)? = nil
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                        ? .white
                        : .white
                            .opacity(1 - Double(abs(offset.width / 50)))

                )
                .background(
                    accessibilityDifferentiateWithoutColor
                        ? nil
                        : RoundedRectangle(cornerRadius: 25)
                            .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)

        }
        .frame(width: 320, height: 180)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 3)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if offset.width < -100 {
                        insertCardtoBack?()
                    } else if offset.width > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )

        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: Card(prompt: "who is", answer: "its me"))
}

