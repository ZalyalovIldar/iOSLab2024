//
//  SavedMovieEntity+CoreDataClass.swift
//  Movies
//
//  Created by Павел Калинин on 30.12.2024.
//
//

import Foundation
import CoreData


public class SavedMovieEntity: NSManagedObject {
    func toMovie() -> Movie? {
        guard let title = title,
              let poster = (try? JSONDecoder().decode(Image.self, from: poster ?? Data())),
              let imagesArray = (try? JSONDecoder().decode([Image].self, from: images ?? Data())),
              let genresArray = (try? JSONDecoder().decode([Genre].self, from: genres ?? Data())) else { return nil }
        return Movie(
            id: Int(id),
            title: title,
            description: body_text,
            yearOfPublication: Int(year),
            trailerUrl: trailer,
            stars: stars,
            runningTime: Int(running_time),
            poster: poster,
            images: imagesArray,
            genres: genresArray,
            rating: imdb_rating
        )
    }
}
