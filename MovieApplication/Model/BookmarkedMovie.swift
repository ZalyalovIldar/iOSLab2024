import Foundation

struct BookmarkedMovie: Codable, Hashable {
    
    let poster: Poster
    let title: String
    let rating: Double
    let year: Int16
    let runningTime: Int16
    let country: String
}

