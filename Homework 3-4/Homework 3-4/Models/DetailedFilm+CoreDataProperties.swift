//
//  DetailedFilm+CoreDataProperties.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 16.01.2025.
//
//

import Foundation
import CoreData

@objc(DetailedFilm)
public class DetailedFilm: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case bodyText = "body_text"
        case country
        case director
        case imdbRating = "imdb_rating"
        case runningTime = "running_time"
        case stars
        case title
        case trailer
        case year
        case genres
        case images
        case poster
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailedFilm> {
        return NSFetchRequest<DetailedFilm>(entityName: "DetailedFilm")
    }

    @NSManaged public var bodyText: String?
    @NSManaged public var country: String?
    @NSManaged public var director: String?
    @NSManaged public var imdbRating: NSNumber?
    @NSManaged public var runningTime: Int16
    @NSManaged public var stars: String?
    @NSManaged public var title: String?
    @NSManaged public var trailer: String?
    @NSManaged public var year: Int16
    @NSManaged public var genres: NSSet?
    @NSManaged public var images: NSSet?
    @NSManaged public var poster: Poster?
    @NSManaged public var film: Film?

    var genresArray: [Genre] {
        return genres?.allObjects as? [Genre] ?? []
    }

    var imagesArray: [Image] {
        return images?.allObjects as? [Image] ?? []
    }

    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Failed to decode DetailedFilm due to missing context.")
        }

        let entity = NSEntityDescription.entity(forEntityName: "DetailedFilm", in: context)!
        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        bodyText = try container.decodeIfPresent(String.self, forKey: .bodyText)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        director = try container.decodeIfPresent(String.self, forKey: .director)
        
        if let rating = try container.decodeIfPresent(Double.self, forKey: .imdbRating) {
            imdbRating = NSNumber(value: rating)
        } else {
            imdbRating = nil
        }
        
        runningTime = try container.decode(Int16.self, forKey: .runningTime)
        stars = try container.decodeIfPresent(String.self, forKey: .stars)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        trailer = try container.decodeIfPresent(String.self, forKey: .trailer)
        year = try container.decode(Int16.self, forKey: .year)

        if let genresArray = try container.decodeIfPresent([Genre].self, forKey: .genres) {
            genres = NSSet(array: genresArray)
        }
        if let imagesArray = try container.decodeIfPresent([Image].self, forKey: .images) {
            let uniqueImages = Set(imagesArray)
            images = NSSet(set: uniqueImages)
        }
        poster = try container.decodeIfPresent(Poster.self, forKey: .poster)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bodyText, forKey: .bodyText)
        try container.encode(country, forKey: .country)
        try container.encode(director, forKey: .director)
        try container.encode(imdbRating?.doubleValue, forKey: .imdbRating)
        try container.encode(runningTime, forKey: .runningTime)
        try container.encode(stars, forKey: .stars)
        try container.encode(title, forKey: .title)
        try container.encode(trailer, forKey: .trailer)
        try container.encode(year, forKey: .year)

        if let genresArray = genres?.allObjects as? [Genre] {
            try container.encode(genresArray, forKey: .genres)
        }
        if let imagesSet = images as? Set<Image> {
            try container.encode(Array(imagesSet), forKey: .images)
        }
        try container.encode(poster, forKey: .poster)
    }
}
