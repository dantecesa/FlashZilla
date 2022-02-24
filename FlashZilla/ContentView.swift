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
        let offset = Double(position - total)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @State var cards: [Card] = Array<Card>.init(repeating: Card.example, count: 10)
    
    var body: some View {
        ZStack {
            Image("background")
                .ignoresSafeArea()
            
            VStack {
                Text("Timer is: XX:XX")
                    .foregroundColor(.secondary)
                ZStack {
                    ForEach(0..<cards.count, id:\.self) { index in
                        CardView(card: cards[index]) {
                            removeCard(at: index)
                        }
                        .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
