//
//  CardView.swift
//  FlashZilla
//
//  Created by Dante Cesa on 2/23/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    @State private var showingAnswer: Bool = false
    @State private var offset: CGSize = .zero
    
    var removal: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            
            VStack {
                Text(card.question)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if showingAnswer == true {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - abs(Double(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            withAnimation {
                showingAnswer.toggle()
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
.previewInterfaceOrientation(.landscapeRight)
    }
}