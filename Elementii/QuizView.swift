//
//  QuizView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

enum GameType {
    case elementIdentification
    case atomicNumberQuiz
    case categoryIdentification
    case periodicTableLocation
    case elementAnagrams
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
    
    // New state variables for different game types
    @State private var currentNumberOptions: [Int] = []
    @State private var currentCategoryOptions: [String] = []
    @State private var selectedGroup: Int = 1
    @State private var selectedPeriod: Int = 1
    @State private var scrambledElementName: String = ""
    @State private var userAnswer: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Theme.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                if currentQuestion < totalQuestions && !showResult {
                    if case .timeBased = quizMode {
                        Text("Time Remaining: \(timeRemaining)s")
                            .font(.title2)
                            .foregroundColor(Theme.text)
                            .padding()
                    }
                    
                    Text("Question \(currentQuestion + 1)/\(totalQuestions)")
                        .font(.subheadline)
                        .foregroundColor(Theme.text)
                        .padding()
                    
                    // Display different question types based on game type
                    switch gameType {
                    case .elementIdentification:
                        Text("What is the symbol for \(elements[currentQuestion].name)?")
                            .font(.title)
                            .foregroundColor(Theme.text)
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
                    
                    case .atomicNumberQuiz:
                        Text("What is the atomic number of \(elements[currentQuestion].name)?")
                            .font(.title)
                            .foregroundColor(Theme.text)
                            .padding()
                        
                        ForEach(currentNumberOptions, id: \.self) { number in
                            Button(action: {
                                checkNumberAnswer(number)
                            }) {
                                Text("\(number)")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.primary)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                    case .categoryIdentification:
                        Text("Which category does \(elements[currentQuestion].name) belong to?")
                            .font(.title)
                            .foregroundColor(Theme.text)
                            .padding()
                        
                        ForEach(currentCategoryOptions, id: \.self) { category in
                            Button(action: {
                                checkCategoryAnswer(category)
                            }) {
                                Text(category)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.primary)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                    case .periodicTableLocation:
                        Text("Where is \(elements[currentQuestion].name) located in the periodic table?")
                            .font(.title)
                            .foregroundColor(Theme.text)
                            .padding()
                        
                        VStack {
                            Text("Group: ")
                            Picker("Group", selection: $selectedGroup) {
                                ForEach(1..<19) { group in
                                    Text("\(group)").tag(group)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                            Text("Period: ")
                            Picker("Period", selection: $selectedPeriod) {
                                ForEach(1..<8) { period in
                                    Text("\(period)").tag(period)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            
                            Button(action: {
                                checkLocationAnswer()
                            }) {
                                Text("Submit Answer")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.accent)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                    case .elementAnagrams:
                        Text("Unscramble this element name:")
                            .font(.title)
                            .foregroundColor(Theme.text)
                            .padding()
                        
                        Text(scrambledElementName)
                            .font(.system(size: 32, weight: .bold))
                            .padding()
                        
                        TextField("Enter element name", text: $userAnswer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                        
                        Button(action: {
                            checkAnagramAnswer()
                        }) {
                            Text("Submit Answer")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.primary)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
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
                            .multilineTextAlignment(.center)
                            .padding()
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
                                .background(Theme.accent)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Back to Quizzes")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.primary)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            startQuiz()
            setupCurrentQuestion()
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
        .navigationBarBackButtonHidden(true)
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
    
    // Setup function to prepare the current question based on game type
    func setupCurrentQuestion() {
        switch gameType {
        case .elementIdentification:
            generateOptions()
        case .atomicNumberQuiz:
            generateNumberOptions()
        case .categoryIdentification:
            generateCategoryOptions()
        case .periodicTableLocation:
            // Reset pickers to default values
            selectedGroup = 1
            selectedPeriod = 1
        case .elementAnagrams:
            scrambleElementName()
        }
    }
    
    // Original options generation for element identification
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
    
    // Generate options for atomic number quiz
    func generateNumberOptions() {
        let correctNumber = elements[currentQuestion].atomicNumber
        var options = [correctNumber]
        
        // Add 3 random incorrect options
        while options.count < 4 {
            let randomNumber = Int.random(in: 1...118)
            if !options.contains(randomNumber) {
                options.append(randomNumber)
            }
        }
        
        currentNumberOptions = options.shuffled()
    }
    
    // Generate options for category identification
    func generateCategoryOptions() {
        // Extract unique categories from your elements
        let allCategories = Array(Set(elements.map { $0.category }))
        
        let correctCategory = elements[currentQuestion].category
        var options = [correctCategory]
        
        // Add up to 3 random incorrect options (or as many as available)
        let incorrectCategories = allCategories.filter { $0 != correctCategory }
        let shuffledIncorrect = incorrectCategories.shuffled()
        let numToAdd = min(3, incorrectCategories.count)
        
        for i in 0..<numToAdd {
            options.append(shuffledIncorrect[i])
        }
        
        currentCategoryOptions = options.shuffled()
    }
    
    // Scramble the element name for anagrams game
    func scrambleElementName() {
        let name = elements[currentQuestion].name
        
        // Keep shuffling until we get a different arrangement
        var scrambled = name
        while scrambled.lowercased() == name.lowercased() {
            scrambled = String(name.lowercased().shuffled())
        }
        
        scrambledElementName = scrambled
        userAnswer = ""
    }
    
    // Original answer checking for element identification
    func checkAnswer(_ answer: String) {
        if answer == elements[currentQuestion].symbol {
            score += 1
        }
        moveToNextQuestion()
    }
    
    // Check answer for atomic number quiz
    func checkNumberAnswer(_ answer: Int) {
        if answer == elements[currentQuestion].atomicNumber {
            score += 1
        }
        moveToNextQuestion()
    }
    
    // Check answer for category identification
    func checkCategoryAnswer(_ answer: String) {
        if answer == elements[currentQuestion].category {
            score += 1
        }
        moveToNextQuestion()
    }
    
    // Check answer for periodic table location
    func checkLocationAnswer() {
        if selectedGroup == elements[currentQuestion].group &&
           selectedPeriod == elements[currentQuestion].period {
            score += 1
        }
        moveToNextQuestion()
    }
    
    // Check answer for element anagrams
    func checkAnagramAnswer() {
        if userAnswer.lowercased() == elements[currentQuestion].name.lowercased() {
            score += 1
        }
        moveToNextQuestion()
    }
    
    // Common function to move to the next question
    func moveToNextQuestion() {
        currentQuestion += 1
        
        if currentQuestion < totalQuestions {
            setupCurrentQuestion()
        } else {
            showResult = true
            timer?.invalidate()
        }
    }
    
    // Reset the quiz
    func resetQuiz() {
        currentQuestion = 0
        score = 0
        showResult = false
        startQuiz()
        setupCurrentQuestion()
    }
    
    // Set celebration message based on score
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

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(gameType: .elementIdentification, quizMode: .fixedQuestions(count: 10))
    }
}
