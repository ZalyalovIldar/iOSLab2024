//
//  FavouriteFilmEntity+CoreDataProperties.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 28.12.2024.
//
//

import Foundation
import CoreData

@objc(FavouriteFilmEntity)
public class FavouriteFilmEntity: NSManagedObject {

}


extension FavouriteFilmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteFilmEntity> {
        return NSFetchRequest<FavouriteFilmEntity>(entityName: "FavouriteFilmEntity")
    }

    @NSManaged public var imagePath: Data?
    @NSManaged public var title: String?
    @NSManaged public var rating: Double
    @NSManaged public var country: String?
    @NSManaged public var year: Int16
    @NSManaged public var runningTime: Int16

}

extension FavouriteFilmEntity : Identifiable {

}
