//
//  SavedMovieEntity+CoreDataProperties.swift
//  Movies
//
//  Created by Павел Калинин on 30.12.2024.
//
//

import Foundation
import CoreData


extension SavedMovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMovieEntity> {
        return NSFetchRequest<SavedMovieEntity>(entityName: "SavedMovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var body_text: String?
    @NSManaged public var year: Int16
    @NSManaged public var trailer: String?
    @NSManaged public var stars: String?
    @NSManaged public var running_time: Int16
    @NSManaged public var poster: Data?
    @NSManaged public var images: Data?
    @NSManaged public var genres: Data?
    @NSManaged public var imdb_rating: Double
    @NSManaged public var date_added: Date?

}

extension SavedMovieEntity : Identifiable {

}
