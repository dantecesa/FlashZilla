//
//  EditCardView.swift
//  FlashZilla
//
//  Created by Dante Cesa on 2/24/22.
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards: [Card] = DataManager.loadCards()
    @State private var newPrompt: String = ""
    @State private var newAnswer: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Add New Card") {
                    TextField("Question", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                        .disabled(newPrompt.isEmpty || newAnswer.isEmpty)
                }
                
                Section {
                    ForEach(0..<cards.count, id:\.self) { index in
                        let card = cards[index]
                        
                        VStack(alignment: .leading) {
                            Text(card.question)
                                .foregroundColor(.primary)
                            Text(card.answer)
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                    .onDelete(perform: removeCard)
                }
            }
            .navigationTitle("Add / Edit Cards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        cards.insert(Card(question: trimmedPrompt, answer: trimmedAnswer), at: 0)
        DataManager.saveCards(cards)
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCard(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        DataManager.saveCards(cards)
    }
}

struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView()
    }
}
