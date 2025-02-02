//
//  Poster+CoreDataProperties.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 16.01.2025.
//
//

import Foundation
import CoreData

@objc(Poster)
public class Poster: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case image
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poster> {
        return NSFetchRequest<Poster>(entityName: "Poster")
    }

    @NSManaged public var image: String?

    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Missing context")
        }

        let entity = NSEntityDescription.entity(forEntityName: "Poster", in: context)!
        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? "default"
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
    }
}

