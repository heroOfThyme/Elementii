import SwiftUI

struct ElementTile: View {
    let element: Element
    
    var body: some View {
        VStack {
            Text(element.symbol)
                .font(.system(size: 14)) // Adjust font size as needed
                .foregroundColor(.white)
            Text(element.name)
                .font(.system(size: 10)) // Adjust font size as needed
                .foregroundColor(.white)
        }
        .frame(width: 50, height: 50)
        .background(Color(element.categoryColor))
        .cornerRadius(5)
    }
}