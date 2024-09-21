//
//  ContentView.swift
//  RandomRockPaperScissors
//
//  Created by Stefan Olarescu on 21.09.2024.
//

import SwiftUI

struct ContentView: View {
    enum Option: String, CaseIterable {
        case rock, paper, scissors
        
        var emoji: String {
            switch self {
            case .rock: return "🪨"
            case .paper: return "📄"
            case .scissors: return "✂️"
            }
        }
        
        func getOptionForWin(_ win: Bool) -> Option {
            switch self {
            case .rock: return win ? .paper : .scissors
            case .paper: return win ? .scissors : .rock
            case .scissors: return win ? .rock : .paper
            }
        }
    }
    private let options = Option.allCases
    
    @State private var optionIndex = Int.random(in: 0..<Option.allCases.count)
    @State private var shouldWin = Bool.random()
    @State private var score = Int.zero
    
    @State private var alertIsPresented = false
    
    private let numberOfQuestions = 10
    @State private var questionsAsked = 1
    
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [.yellow, .orange],
                center: .center,
                startRadius: .zero,
                endRadius: 900
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Random 🪨📄✂️")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("You are up against \(options[optionIndex].emoji).")
                            .font(.system(.title3))
                        
                        Text("What do you play in order to \(shouldWin ? "win" : "lose")?")
                            .font(.title2.weight(.semibold))
                    }
                    
                    HStack {
                        ForEach(options, id: \.self) { option in
                            Button(option.emoji) {
                                buttonTapped(option: option)
                            }
                            .font(.system(.largeTitle))
                            .padding(20)
                            .background(.secondary)
                            .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 16))
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(
            "Game Over",
            isPresented: $alertIsPresented
        ) {
            Button("Restart") {
                reset()
            }
        } message: {
            Text("Your final score is \(score).")
        }
    }
    
    func buttonTapped(option: Option) {
        if option == options[optionIndex].getOptionForWin(shouldWin) {
            score += 1
        }
        
        if questionsAsked == numberOfQuestions {
            alertIsPresented = true
        } else {
            askQuestion()
        }
    }
    
    func askQuestion() {
        questionsAsked += 1
        optionIndex = Int.random(in: 0..<Option.allCases.count)
        shouldWin.toggle()
    }
    
    func reset() {
        score = .zero
        questionsAsked = .zero
        askQuestion()
    }
}

#Preview {
    ContentView()
}
