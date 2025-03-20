import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    
}

extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var poster: String?
}

extension MovieEntity : Identifiable {

}
