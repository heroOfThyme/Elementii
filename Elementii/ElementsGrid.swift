import SwiftUI

struct ElementsGrid: View {
    let elements: [Element]
    @Binding var scale: CGFloat
    
    var body: some View {
        ForEach(elements) { element in
            ElementTile(element: element)
                .position(
                    x: CGFloat(element.position.x) * 50, // Adjust spacing as needed
                    y: CGFloat(element.position.y) * 50  // Adjust spacing as needed
                )
        }
    }
}