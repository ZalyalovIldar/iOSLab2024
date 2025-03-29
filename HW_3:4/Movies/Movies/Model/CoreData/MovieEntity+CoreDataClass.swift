//
//  MovieEntity+CoreDataClass.swift
//  Movies
//
//  Created by Павел Калинин on 03.01.2025.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    func toMovie() -> Movie? {
        guard let title = title,
              let poster = (try? JSONDecoder().decode(Image.self, from: poster ?? Data())) else { return nil }
        return Movie(
            id: Int(id),
            title: title,
            description: nil,
            yearOfPublication: nil,
            trailerUrl: nil,
            stars: nil,
            runningTime: nil,
            poster: poster,
            images: nil,
            genres: nil,
            rating: nil
        )
    }
}
