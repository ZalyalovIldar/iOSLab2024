//
//  TopMovieEntity+CoreDataProperties.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 13.01.2025.
//
//

import Foundation
import CoreData

@objc(TopMovieEntity)
public class TopMovieEntity: NSManagedObject {

}

extension TopMovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopMovieEntity> {
        return NSFetchRequest<TopMovieEntity>(entityName: "TopMovieEntity")
    }

    @NSManaged public var movieId: Int16
    @NSManaged public var poster: Data?

}

extension TopMovieEntity : Identifiable {

}
