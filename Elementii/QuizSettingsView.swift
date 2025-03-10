//
//  QuizSettingsView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-03.
//

import SwiftUI

struct QuizSettingsView: View {
    let games = [
        Game(name: "Element Identification", description: "Guess the element from its symbol.", type: .elementIdentification, icon: "atom", color: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.3882353008, alpha: 1))), // Red
        Game(name: "Atomic Numbers", description: "Match elements with their atomic numbers.", type: .atomicNumberQuiz, icon: "number", color: Color(#colorLiteral(red: 0.3647058904, green: 0.5882353187, blue: 0.9254902005, alpha: 1))), // Blue
        Game(name: "Element Categories", description: "Identify which category elements belong to.", type: .categoryIdentification, icon: "folder", color: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.4196078479, alpha: 1))), // Green
        Game(name: "Periodic Table", description: "Identify where elements are located.", type: .periodicTableLocation, icon: "tablecells", color: Color(#colorLiteral(red: 0.6078431606, green: 0.3176470697, blue: 0.8235294223, alpha: 1))), // Purple
        Game(name: "Element Anagrams", description: "Unscramble element names.", type: .elementAnagrams, icon: "textformat.abc", color: Color(#colorLiteral(red: 0.9529411793, green: 0.6431372762, blue: 0.3764705956, alpha: 1))) // Orange
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Think you know your elements? Try out some quizzes!")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Theme.text)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(games, id: \.name) { game in
                        NavigationLink(destination: QuizView(gameType: game.type, quizMode: .fixedQuestions(count: 10))) {
                            GameCard(game: game)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .background(Theme.background)
        .navigationTitle("Quizzes")
    }
}

struct GameCard: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Fixed size top portion with icon
            HStack(alignment: .center) {
                // Icon in a circle
                ZStack {
                    Circle()
                        .fill(game.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: game.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(game.color)
                }
                
                Spacer()
                
                // Chevron indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.text.opacity(0.3))
            }
            .frame(height: 60) // Fixed height for the top portion
            
            // Fixed spacing
            Spacer()
                .frame(height: 12)
            
            // Title with fixed height
            Text(game.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.text)
                .lineLimit(2)
                .frame(height: 46, alignment: .top) // Fixed height for two lines
            
            // Description with fixed height
            Text(game.description)
                .font(.system(size: 14))
                .foregroundStyle(Theme.text.opacity(0.7))
                .lineLimit(3) // Limit to only 2 lines for consistency
                .frame(height: 60, alignment: .top) // Fixed height for two lines
        }
        .padding(16)
        .frame(height: 190) // Fixed exact height
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.background)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(game.color.opacity(0.2), lineWidth: 1)
        )
    }
}

struct Game {
    let name: String
    let description: String
    let type: GameType
    let icon: String
    let color: Color
}

#Preview {
    NavigationView {
        QuizSettingsView()
    }
}
