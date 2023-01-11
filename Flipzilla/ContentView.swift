//
//  ContentView.swift
//  Flipzilla
//
//  Created by Elie Cohen on 11/11/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x:offset*1, y: offset*3)
    }
}


struct ContentView: View {

    @State private var cards = Array<Card>(repeating: Card.example, count: 6)
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    @State private var timeRemaining = 20
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var showingEditScreen = false
    

    var body: some View {
        ZStack{
            Image("grid-0041")
                .resizable()
                .ignoresSafeArea()
                .scaledToFit()
            VStack{
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical,5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack{
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index != cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding(.horizontal, 20)
                        .padding(.vertical,5)
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .padding(.vertical,30)
                }
            }
            .sheet(isPresented: $showingEditScreen) {
                EditView()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .background(.white)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                            .padding()
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack{
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as incorrect")

                        Spacer()

                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as good")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
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
            isActive = false
            if newPhase == .active && !cards.isEmpty {
                isActive = true
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else {return}
        cards.remove(at:index)
        print("Index = \(index)")
        print("cards.count = \(cards.count)")
        isActive = !cards.isEmpty
    }

    func resetCards() {
        cards = Array<Card>(repeating: Card.example, count: 6)
        timeRemaining = 20
        isActive = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
