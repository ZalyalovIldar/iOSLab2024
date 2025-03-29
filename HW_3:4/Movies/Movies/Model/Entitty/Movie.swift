//
//  Movie.swift
//  Movies
//
//  Created by Павел Калинин on 21.12.2024.
//
import CoreData

struct Movie: Codable {
    let id: Int
    let title: String
    let description: String?
    let yearOfPublication: Int?
    let trailerUrl: String?
    let stars: String?
    let runningTime: Int?
    let poster: Image
    let images: [Image]?
    let genres: [Genre]?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, poster, description = "body_text", yearOfPublication = "year", trailerUrl = "trailer", stars, runningTime = "running_time", images, genres, rating = "imdb_rating"
    }
    
    func toSavedMovieEntity(context: NSManagedObjectContext) -> SavedMovieEntity{
        let entity = SavedMovieEntity(context: context)
        entity.id = Int64(id)
        entity.title = title
        entity.body_text = description
        entity.year = Int16(yearOfPublication ?? 0)
        entity.trailer = trailerUrl
        entity.stars = stars
        entity.running_time = Int16(runningTime ?? 0)
        entity.poster = try? JSONEncoder().encode(poster)
        entity.images = try? JSONEncoder().encode(images)
        entity.genres = try? JSONEncoder().encode(genres)
        entity.imdb_rating = rating ?? 0.0
        entity.date_added = Date()
        return entity
    }
    
    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity{
        let entity = MovieEntity(context: context)
        entity.id = Int64(id)
        entity.title = title
        entity.body_text = description
        entity.year = Int16(yearOfPublication ?? 0)
        entity.trailer = trailerUrl
        entity.stars = stars
        entity.running_time = Int16(runningTime ?? 0)
        entity.poster = try? JSONEncoder().encode(poster)
        entity.images = try? JSONEncoder().encode(images)
        entity.genres = try? JSONEncoder().encode(genres)
        entity.imdb_rating = rating ?? 0.0
        return entity
    }
}

