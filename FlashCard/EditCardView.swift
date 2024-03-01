//
//  EditCardView.swift
//  FlashCard
//
//  Created by 武林慎太郎 on 2024/02/26.
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var editCardVm = EditCardViewModel()
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $editCardVm.newPrompt)
                    TextField("Answer", text: $editCardVm.newAnswer)
                    Button("Add Card", action: {
                        editCardVm.addCard()
                        editCardVm.newPrompt = ""
                        editCardVm.newAnswer = ""
                    })
                }

                Section {
                    ForEach(0..<editCardVm.cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(editCardVm.cards[index].prompt)
                                .font(.headline)
                            Text(editCardVm.cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: editCardVm.removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .onAppear(perform: editCardVm.loadData)
        }
    }

}
#Preview {
    EditCardView()
}
