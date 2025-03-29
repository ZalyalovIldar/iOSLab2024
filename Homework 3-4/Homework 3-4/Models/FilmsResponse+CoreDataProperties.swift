//
//  FilmsResponse+CoreDataProperties.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 16.01.2025.
//
//

import Foundation
import CoreData

@objc(FilmsResponse)
public class FilmsResponse: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmsResponse> {
        return NSFetchRequest<FilmsResponse>(entityName: "FilmsResponse")
    }

    @NSManaged public var count: Int16
    @NSManaged public var next: String?
    @NSManaged public var previous: String?
    @NSManaged public var page: Int16
    @NSManaged public var results: NSSet?

    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Failed to decode FilmsResponse due to missing context.")
        }

        let entity = NSEntityDescription.entity(forEntityName: "FilmsResponse", in: context)!
        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decode(Int16.self, forKey: .count)
        next = try container.decodeIfPresent(String.self, forKey: .next)
        previous = try container.decodeIfPresent(String.self, forKey: .previous)

        if let filmArray = try container.decodeIfPresent([Film].self, forKey: .results) {
            let filmSet = NSMutableSet()
            
            for film in filmArray {
                let filmEntity = Film(context: context)
                filmEntity.id = film.id
                filmEntity.title = film.title
                filmEntity.poster = film.poster
                filmSet.add(filmEntity)
            }

            self.results = filmSet
        } else {
            results = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(next, forKey: .next)
        try container.encode(previous, forKey: .previous)

        if let resultsArray = results?.allObjects as? [Film] {
            try container.encode(resultsArray, forKey: .results)
        } else {
            try container.encode([Film](), forKey: .results)
        }
    }
    
}

extension FilmsResponse {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: Film)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: Film)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)
}

