import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func addMovie(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = MovieEntity(context: context)
        
        entity.title = model.title
        entity.id = Int64(model.id)
        entity.movieDescription = model.movieDescription
        entity.poster = PosterObject(poster: model.poster)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
        
        do{
            try context.save()
            completion(.success(()))
        } catch {print(error.localizedDescription)}
    }
}

