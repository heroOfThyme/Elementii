struct QuizView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 20) {
            if currentQuestion < elements.count {
                Text("What is the symbol for \(elements[currentQuestion].name)?")
                    .font(.title)
                    .padding()
                
                ForEach(elements.shuffled().prefix(4), id: \.symbol) { element in
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
            } else {
                Text("Quiz Over! Your score is \(score)/\(elements.count)")
                    .font(.title)
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
        .padding()
    }
    
    func checkAnswer(_ answer: String) {
        if answer == elements[currentQuestion].symbol {
            score += 1
        }
        currentQuestion += 1
    }
    
    func resetQuiz() {
        currentQuestion = 0
        score = 0
    }
}