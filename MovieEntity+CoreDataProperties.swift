//
//  MovieEntity+CoreDataProperties.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var imagePath: Data?
    @NSManaged public var title: String?

}

extension MovieEntity : Identifiable {

}
