import Foundation

// Define the Element model
struct Element: Identifiable, Codable {
    let id = UUID()
    let name: String
    let symbol: String
    let atomicNumber: Int
    let category: String
    let fact: String
    let color: String
    let wikipediaLink: String
}

// Load the JSON data
extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}