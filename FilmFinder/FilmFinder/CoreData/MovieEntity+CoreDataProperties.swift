//
//  MovieEntity+CoreDataProperties.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 13.01.2025.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {

}

extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var movieId: Int16
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var genre: String?
    @NSManaged public var runningTime: Int16
    @NSManaged public var rating: Double
    @NSManaged public var year: Int16
    @NSManaged public var poster: Data?

}

extension MovieEntity : Identifiable {

}
