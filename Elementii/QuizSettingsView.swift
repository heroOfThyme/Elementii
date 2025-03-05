//
//  QuizSettingsView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-03.
//


import SwiftUI

struct QuizSettingsView: View {
    let games = [
        Game(name: "Element Identification", description: "Guess the element from its symbol", type: .elementIdentification, icon: "atom"),
        // Add more games here later
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(games, id: \.name) { game in
                    NavigationLink(destination: QuizView(gameType: game.type, quizMode: .fixedQuestions(count: 10))) {
                        GameCard(game: game)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Quizes")
    }
}

struct GameCard: View {
    let game: Game
    
    var body: some View {
        VStack {
            Image(systemName: game.icon)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .padding(.top, 10)
            Text(game.name)
                .font(.headline)
                .padding(.top, 5)
            Text(game.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue, lineWidth: 2)
        )
        .shadow(radius: 5)
    }
}

struct Game {
    let name: String
    let description: String
    let type: GameType
    let icon: String
}
