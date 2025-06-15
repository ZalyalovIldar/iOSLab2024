//
//  FavouriteFilmEntity+CoreDataProperties.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//
//

import Foundation
import CoreData


extension FavouriteFilmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteFilmEntity> {
        return NSFetchRequest<FavouriteFilmEntity>(entityName: "FavouriteFilmEntity")
    }

    @NSManaged public var country: String?
    @NSManaged public var imagePath: Data?
    @NSManaged public var rating: Double
    @NSManaged public var runningTime: Int16
    @NSManaged public var title: String?
    @NSManaged public var year: Int16
    @NSManaged public var genre: String?

}

extension FavouriteFilmEntity : Identifiable {

}
