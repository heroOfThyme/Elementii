struct PeriodicGridView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 18), spacing: 10) {
                ForEach(elements) { element in
                    ElementTile(element: element)
                }
            }
            .padding()
        }
        .navigationTitle("Periodic Table")
    }
}

struct ElementTile: View {
    let element: Element
    
    var body: some View {
        VStack {
            Text(element.symbol)
                .font(.title)
                .foregroundColor(.white)
            Text(element.name)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(width: 50, height: 50)
        .background(Color(element.categoryColor))
        .cornerRadius(10)
    }
}