//
//  DetailMovie.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 05.01.2025.
//

import Foundation
import UIKit

class DetailMovie: Codable, Hashable {
    let id: Int
    let title: String
    let text: String
    let runningTime: Int?
    let rating: Double?
    let year: Int
    let genres: [Genre]
    var stars: String
    var director: String
    var writer: String
    var trailer: String
    var images: [MovieImages]
    let poster: Poster
    let dataPoster: Data?
    
    init(id: Int, title: String, text: String, runningTime: Int?, rating: Double?, year: Int, genres: [Genre], stars: String, director: String, writer: String, trailer: String, images: [MovieImages], poster: Poster, dataPoster: Data?) {
        self.id = id
        self.title = title
        self.text = text
        self.runningTime = runningTime
        self.rating = rating
        self.year = year
        self.genres = genres
        self.stars = stars
        self.director = director
        self.writer = writer
        self.trailer = trailer
        self.images = images
        self.poster = poster
        self.dataPoster = dataPoster
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case text = "body_text"
        case runningTime = "running_time"
        case rating = "imdb_rating"
        case year
        case genres
        case stars
        case director
        case writer
        case trailer
        case images
        case poster
        case dataPoster
    }

    static func == (lhs: DetailMovie, rhs: DetailMovie) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.text == rhs.text &&
               lhs.runningTime == rhs.runningTime &&
               lhs.rating == rhs.rating &&
               lhs.year == rhs.year &&
               lhs.genres == rhs.genres &&
               lhs.stars == rhs.stars &&
               lhs.director == rhs.director &&
               lhs.writer == rhs.writer &&
               lhs.trailer == rhs.trailer &&
               lhs.images == rhs.images &&
               lhs.poster == rhs.poster &&
               lhs.dataPoster == rhs.dataPoster
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(text)
        hasher.combine(runningTime)
        hasher.combine(rating)
        hasher.combine(year)
        hasher.combine(genres)
        hasher.combine(stars)
        hasher.combine(director)
        hasher.combine(writer)
        hasher.combine(trailer)
        hasher.combine(images)
        hasher.combine(poster)
        hasher.combine(dataPoster)
    }
}

class FavoriteMovieFromNetwork: Codable, Hashable {
    let stars: String
    let director: String
    let writer: String
    let trailer: String
    var images: [MovieImages]
    
    init(stars: String, director: String, writer: String, trailer: String, images: [MovieImages]) {
        self.stars = stars
        self.director = director
        self.writer = writer
        self.trailer = trailer
        self.images = images
    }

    static func == (lhs: FavoriteMovieFromNetwork, rhs: FavoriteMovieFromNetwork) -> Bool {
        return lhs.stars == rhs.stars &&
               lhs.director == rhs.director &&
               lhs.writer == rhs.writer &&
               lhs.trailer == rhs.trailer &&
               lhs.images == rhs.images
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(stars)
        hasher.combine(director)
        hasher.combine(writer)
        hasher.combine(trailer)
        hasher.combine(images)
    }
}
