//
//  QuizView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

enum GameType {
    case elementIdentification
    // Add more game types here later
}

enum QuizMode: Hashable {
    case fixedQuestions(count: Int)
    case timeBased(seconds: Int)
}

struct QuizView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    let gameType: GameType
    let quizMode: QuizMode
    
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var showResult = false
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer? = nil
    @State private var currentOptions: [Element] = []
    @State private var showCelebration = false
    @State private var celebrationMessage = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if currentQuestion < totalQuestions && !showResult {
                    if case .timeBased = quizMode {
                        Text("Time Remaining: \(timeRemaining)s")
                            .font(.title2)
                            .padding()
                    }
                    
                    Text("Question \(currentQuestion + 1)/\(totalQuestions)")
                        .font(.subheadline)
                        .padding()
                    
                    Text("What is the symbol for \(elements[currentQuestion].name)?")
                        .font(.title)
                        .padding()
                    
                    ForEach(currentOptions, id: \.symbol) { element in
                        Button(action: {
                            checkAnswer(element.symbol)
                        }) {
                            Text(element.symbol)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        QuizSettingsView()
                    }) {
                        Text("Quit")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    VStack {
                        Text("Quiz Over! Your score is \(score)/\(totalQuestions)")
                            .font(.title)
                        Text(celebrationMessage)
                            .font(.headline)
                            .padding()
                        Button(action: {
                            resetQuiz()
                        }) {
                            Text("Play Again")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
            
        }
        .onAppear {
            startQuiz()
            generateOptions()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .onChange(of: showResult) { _, newValue in
            if newValue {
                showCelebration = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showCelebration = false
                }
                setCelebrationMessage()
            }
        }
    }
    
    var totalQuestions: Int {
        switch quizMode {
        case .fixedQuestions(let count):
            return min(count, elements.count)
        case .timeBased:
            return elements.count
        }
    }
    
    func startQuiz() {
        if case .timeBased(let seconds) = quizMode {
            timeRemaining = seconds
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    showResult = true
                    timer?.invalidate()
                }
            }
        }
    }
    
    func generateOptions() {
        let correctElement = elements[currentQuestion]
        var options = [correctElement]
        
        // Add 3 random incorrect options
        while options.count < 4 {
            let randomElement = elements.randomElement()!
            if !options.contains(where: { $0.symbol == randomElement.symbol }) {
                options.append(randomElement)
            }
        }
        
        // Shuffle the options so the correct answer isn't always in the same position
        currentOptions = options.shuffled()
    }
    
    func checkAnswer(_ answer: String) {
        if answer == elements[currentQuestion].symbol {
            score += 1
        }
        currentQuestion += 1
        
        if currentQuestion < totalQuestions {
            generateOptions()
        } else {
            showResult = true
            timer?.invalidate()
        }
    }
    
    func resetQuiz() {
        currentQuestion = 0
        score = 0
        showResult = false
        startQuiz()
        generateOptions()
    }
    
    func setCelebrationMessage() {
        let percentage = Double(score) / Double(totalQuestions)
        
        if percentage >= 0.9 {
            celebrationMessage = "Amazing! 🎉"
        } else if percentage >= 0.7 {
            celebrationMessage = "Great job! 👍"
        } else if percentage >= 0.5 {
            celebrationMessage = "Not bad! 😊"
        } else {
            celebrationMessage = "Keep practicing! 💪"
        }
    }
}
