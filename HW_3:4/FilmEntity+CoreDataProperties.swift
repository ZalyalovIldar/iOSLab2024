//
//  FilmEntity+CoreDataProperties.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//
//

import Foundation
import CoreData


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
