//
//  FilmEntity+CoreDataProperties.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 25.12.2024.
//
//

import Foundation
import CoreData

@objc(FilmEntity)
public class FilmEntity: NSManagedObject {

}

extension FilmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmEntity> {
        return NSFetchRequest<FilmEntity>(entityName: "FilmEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var imagePath: Data?
    @NSManaged public var title: String?

}

extension FilmEntity : Identifiable {

}
