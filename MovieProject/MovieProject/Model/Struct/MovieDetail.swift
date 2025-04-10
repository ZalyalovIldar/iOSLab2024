import Foundation
import UIKit

struct MovieDetail: Codable {
    
    let id: Int
    let title: String
    let description: String
    let raiting: Double?
    let poster: Poster
    let year: Int16
    let duration: Int16
    let genres: [Genre]
    let stars: String
    let images: [Images]
    let trailer: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "body_text"
        case raiting = "imdb_rating"
        case poster
        case year
        case duration = "running_time"
        case genres 
        case stars
        case images
        case trailer
        case country
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Images: Codable {
    let image: String
}


