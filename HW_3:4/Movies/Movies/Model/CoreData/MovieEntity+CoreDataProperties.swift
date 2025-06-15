//
//  MovieEntity+CoreDataProperties.swift
//  Movies
//
//  Created by Павел Калинин on 03.01.2025.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var body_text: String?
    @NSManaged public var genres: Data?
    @NSManaged public var id: Int64
    @NSManaged public var images: Data?
    @NSManaged public var imdb_rating: Double
    @NSManaged public var poster: Data?
    @NSManaged public var running_time: Int16
    @NSManaged public var stars: String?
    @NSManaged public var title: String?
    @NSManaged public var trailer: String?
    @NSManaged public var year: Int16

}

extension MovieEntity : Identifiable {

}
