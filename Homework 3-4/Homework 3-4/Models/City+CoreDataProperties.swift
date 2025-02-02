//
//  City+CoreDataProperties.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 16.01.2025.
//
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case slug
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?
    @NSManaged public var slug: String?

    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Failed to decode City due to missing context.")
        }

        let entity = NSEntityDescription.entity(forEntityName: "City", in: context)!
        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(slug, forKey: .slug)
    }
}
