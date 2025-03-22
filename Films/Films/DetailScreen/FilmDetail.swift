//
//  FilmDetail.swift
//  Films
//
//  Created by Артур Мавликаев on 10.01.2025.
//

import Foundation

struct FilmDetail: Decodable {
    let id: Int
    let title: String
    let year: Int?
    let runningTime: Int?
    let genres: [Genre]
    let description: String?
    let stars: String?
    let trailer: String?
    let poster: Poster
    let imdbRating: Double?

    struct Genre: Decodable {
        let id: Int
        let name: String
    }

    struct Poster: Decodable {
        let image: String
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, year, runningTime = "running_time", genres, description, stars, trailer, poster, imdbRating = "imdb_rating"
    }
    init(
        
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        self.id = try container
            .decode(
                Int.self,
                forKey: .id
            )
        self.title = try container
            .decode(
                String.self,
                forKey: .title
            )
        self.year = try container
            .decodeIfPresent(
                Int.self,
                forKey: .year
            )
        self.runningTime = try container
            .decodeIfPresent(
                Int.self,
                forKey: .runningTime
            )
        self.genres = try container
            .decode(
                [FilmDetail.Genre].self,
                forKey: .genres
            )
        self.description = try container
            .decodeIfPresent(
                String.self,
                forKey: .description
            )
        self.stars = try container
            .decodeIfPresent(
                String.self,
                forKey: .stars
            )
        self.trailer = try container
            .decodeIfPresent(
                String.self,
                forKey: .trailer
            )
        do {
            self.poster = try container
                .decode(
                    Poster.self,
                    forKey: .poster
                )
        } catch {
            self.poster = Poster(
                image: "https://sun9-27.userapi.com/impg/vGLmVc5Th37dgwtapYPI8gFlNK7KAk4RVCnbUQ/B6TRJ-sElUU.jpg?size=382x512&quality=95&sign=3f3405d5d5696dbee94b521557124c3b&type=album"
            )
        }
        self.imdbRating = try container
            .decodeIfPresent(
                Double.self,
                forKey: .imdbRating
            )
    }
}
