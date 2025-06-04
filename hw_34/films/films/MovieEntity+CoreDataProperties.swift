//
//  MovieEntity+CoreDataProperties.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import Foundation
import CoreData

extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var poster: String
    @NSManaged public var isFavorite: Bool
}
