//
//  File.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 25.12.2024.
//

import Foundation

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
