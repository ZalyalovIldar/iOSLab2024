//
//  Film.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//

import Foundation

struct FilmResponce: Codable {
    let results: [Movie]
}

struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let poster: Poster
    
    /// Ускорение работы Hashable тк при работе с applySnapshot'ом diffableDataSource'а было долгое ожидание (2.8 секунд)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Poster: Codable, Hashable {
    let image: String
}

enum CollectionViewSections {
    case popularFilms
    case defaultFilms
}

struct FilmWithInfo: Codable {
    
    let id: Int
    let title: String
    let description: String
    let year: Int
    let country: String
    let images: [FilmImage]
    let poster: Poster
    let rating: Double?
    let runningTime: Int?
    let trailerLink: String?
    let stars: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "body_text"
        case year
        case country
        case images
        case poster
        case rating = "imdb_rating"
        case runningTime = "running_time"
        case trailerLink = "trailer"
        case stars
    }
}

struct FilmImage: Codable {
    
    let image: String
}
