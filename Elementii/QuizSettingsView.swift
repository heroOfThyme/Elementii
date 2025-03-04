// QuizSettingsView.swift
import SwiftUI

struct QuizSettingsView: View {
    @State private var selectedGame: GameType = .elementIdentification
    @State private var selectedMode: QuizMode = .fixedQuestions(count: 10)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Game")) {
                    Picker("Game", selection: $selectedGame) {
                        Text("Element Identification").tag(GameType.elementIdentification)
                        // Add more games here later
                    }
                }
                
                Section(header: Text("Select Mode")) {
                    Picker("Mode", selection: $selectedMode) {
                        Text("10 Questions").tag(QuizMode.fixedQuestions(count: 10))
                        Text("30 Questions").tag(QuizMode.fixedQuestions(count: 30))
                        Text("Time-Based (1 Minute)").tag(QuizMode.timeBased(seconds: 60))
                    }
                }
                
                NavigationLink(destination: QuizView(gameType: selectedGame, quizMode: selectedMode)) {
                    Text("Start Quiz")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Quiz Settings")
        }
    }
}