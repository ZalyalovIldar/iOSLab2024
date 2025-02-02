//
//  Genre+CoreDataProperties.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 16.01.2025.
//
//

import Foundation
import CoreData

@objc(Genre)
public class Genre: NSManagedObject, Codable {

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var slug: String?
    @NSManaged public var detailedFilm: DetailedFilm?

    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Failed to decode Genre due to missing context.")
        }

        let entity = NSEntityDescription.entity(forEntityName: "Genre", in: context)!
        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int16.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(slug, forKey: .slug)
    }
}

