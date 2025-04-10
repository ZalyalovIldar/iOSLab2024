import Foundation

struct MovieResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int64
    let title: String
    let poster: Poster
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case poster
    }
}

struct Poster: Codable {
    let image: String
    
}



