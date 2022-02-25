//
//  CardView.swift
//  FlashZilla
//
//  Created by Dante Cesa on 2/23/22.
//

import SwiftUI

extension Shape {
    func fill(using offset: CGSize) -> some View {
        if offset == .zero {
            return self.fill(.white)
        } else if offset.width < 0 {
            return self.fill(.red)
        } else {
            return self.fill(.green)
        }
    }
}

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var feedback = UINotificationFeedbackGenerator()
    
    let card: Card
    @State private var offset: CGSize = .zero
    @State private var showingAnswer: Bool = false
    
    var removal: ((Bool) -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width) / 50))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(using: offset)
                )
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(showingAnswer ? card.answer : card.question)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.question)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if showingAnswer == true {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .accessibilityAddTraits(.isButton)
        .opacity(2 - abs(Double(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width < 0 {
                            feedback.notificationOccurred(.error)
                            removal?(true)
                            withAnimation {
                                offset = .zero
                            }
                        } else {
                            removal?(false)
                        }
                    } else {
                        withAnimation {
                            offset = .zero
                        }
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
