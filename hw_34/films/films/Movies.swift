//
//  Movies.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct MoviePoster: Codable {
    let image: String
    let source: Source?
}

struct Source: Codable {
    let name: String?
    let link: String?
}

struct Movie: Codable {
    let id: Int
    let title: String
    let year: Int?
    let running_time: Int?
    let poster: MoviePoster
    let description: String?
    let body_text: String?
    let genres: [Genre]?
    let imdb_rating: Double?
    let stars: String?
    let trailer: String?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case id, title, year, running_time, poster, description, body_text, genres, stars, trailer, images
        case imdb_rating = "imdb_rating"
    }
}

struct Image: Codable {
    let image: String
    let source: Source?
}

struct MovieListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Movie]
}
