//
//  Structs.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 12.01.25.
//

import UIKit

struct FilmImage: Codable {
    let image: String
}

enum CollectionViewSections {
    case main
}

struct FilmResponce: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Film]
}

struct Film: Codable, Hashable {
    let id: Int
    let title: String
    let poster: Poster
}

struct Poster: Codable, Hashable {
    let image: String
}

struct City: Codable, Hashable {
    let slug: String
    let name: String
}

struct FilmDetail: Codable {
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
    let genres: [Genre]
    
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
        case genres
    }
}

struct FavouriteFilm: Codable, Hashable {
    let poster: Poster
    let title: String
    let rating: Double
    let year: Int16
    let runningTime: Int16
    let country: String
}

struct Genre: Codable {
    let name: String
}
