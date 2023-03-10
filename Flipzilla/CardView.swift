//
//  CardView.swift
//  Flipzilla
//
//  Created by Elie Cohen on 11/11/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removal: (() -> Void)? = nil

    @State private var feedback = UINotificationFeedbackGenerator()

    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white.opacity(1-Double(abs(offset.width/50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)

            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.prompt : card.answer)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    if isShowingAnswer {
                        Text(card.prompt)
                            .font(.body)
                            .foregroundColor(.gray)
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.black)
                    } else {
                        Text(card.prompt)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 400, height: 240)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 2.5, y:0)
        .opacity(2-Double(abs(offset.width/50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            feedback.notificationOccurred(.success)
                        } else {
                            feedback.notificationOccurred(.error)
                        }
                        removal?()
                    } else {
//                        withAnimation{
                            offset = .zero
  //                      }
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .example)
    }
}
