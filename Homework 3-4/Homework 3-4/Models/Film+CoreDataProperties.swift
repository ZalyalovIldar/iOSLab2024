import Foundation
import CoreData

@objc(Film)
public class Film: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case poster
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var poster: Poster?
    @NSManaged public var filmsResponse: FilmsResponse?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var detailedFilm: DetailedFilm?

    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            fatalError("Failed to decode Film due to missing context.")
        }

        let entity = NSEntityDescription.entity(forEntityName: "Film", in: context)!
        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int16.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        poster = try container.decodeIfPresent(Poster.self, forKey: .poster)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(poster, forKey: .poster)
    }
}
