//
//  ContentView.swift
//  FlashZilla
//
//  Created by Dante Cesa on 2/21/22.
//

import CoreHaptics
import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    @State var cards: [Card] = []
    @State private var isActive: Bool = true
    @State private var timeRemaining: Int = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingEditScreen: Bool = false
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .ignoresSafeArea()
            
            VStack {
                Text("Time remaining: \(timeRemaining)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack {
                    ForEach(0..<cards.count, id:\.self) { index in
                        CardView(card: cards[index]) {
                            removeCard(at: index)
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again?", action: resetGame)
                        .padding()
                        .foregroundColor(.black)
                        .background(.white)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Label("Add Cards", systemImage: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.75))
                            .clipShape(Capsule())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.body)
            .padding(.horizontal, 60)
            .padding(.vertical, 40)
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            removeCard(at: cards.count - 1)
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.75))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer incorrect.")
                        
                        Spacer()
                        
                        Button {
                            removeCard(at: cards.count - 1)
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.75))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(.horizontal, 50)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetGame, content: EditCardView.init)
        .onAppear(perform: resetGame)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        withAnimation {
            cards.remove(at: index)
        }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetGame() {
        timeRemaining = 100
        isActive = true
        loadCards()
    }
    
    func loadCards() {
        if let data = UserDefaults.standard.data(forKey: "SavedCards") {
            if let decodedCards = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decodedCards
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
