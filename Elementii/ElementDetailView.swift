import SwiftUI

struct ElementDetailView: View {
    let element: Element
    
    var body: some View {
        VStack(spacing: 20) {
            // Element Symbol
            Text(element.symbol)
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
            
            // Element Name and Atomic Number
            Text(element.name)
                .font(.title)
                .foregroundColor(.white)
            Text("Atomic Number: \(element.atomicNumber)")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            
            // Fun Fact
            Text(element.fact)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.white)
            
            // Wikipedia Link
            Link("Learn More on Wikipedia", destination: URL(string: element.wikipediaLink)!)
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(element.color))
        .edgesIgnoringSafeArea(.all)
    }
}