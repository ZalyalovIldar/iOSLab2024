//
//  BookmarkedMovieEntity+CoreDataProperties.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//
//

import Foundation
import CoreData


extension BookmarkedMovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkedMovieEntity> {
        return NSFetchRequest<BookmarkedMovieEntity>(entityName: "BookmarkedMovieEntity")
    }

    @NSManaged public var country: String?
    @NSManaged public var imagePath: Data?
    @NSManaged public var rating: Double
    @NSManaged public var runningTime: Int16
    @NSManaged public var title: String?
    @NSManaged public var year: Int16

}

extension BookmarkedMovieEntity : Identifiable {

}
