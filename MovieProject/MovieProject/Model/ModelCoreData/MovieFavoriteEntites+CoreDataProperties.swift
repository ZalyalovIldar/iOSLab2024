import Foundation
import CoreData

@objc(MovieFavoriteEntites)
public class MovieFavoriteEntites: NSManagedObject {

}

extension MovieFavoriteEntites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieFavoriteEntites> {
        return NSFetchRequest<MovieFavoriteEntites>(entityName: "MovieFavoriteEntites")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var poster: String?
    @NSManaged public var raiting: Double
    @NSManaged public var duration: Int16
    @NSManaged public var genre: String?
    @NSManaged public var year: Int16

}

extension MovieFavoriteEntites : Identifiable {

}
