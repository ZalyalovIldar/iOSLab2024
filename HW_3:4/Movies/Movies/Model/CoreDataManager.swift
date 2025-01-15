//
//  CoreDataManager.swift
//  Movies
//
//  Created by Павел Калинин on 26.12.2024.
//
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext () {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveSavedMovie(movie: Movie) {
        _ = movie.toSavedMovieEntity(context: viewContext)
        saveContext()
    }
    
    func fetchSavedMovies() throws -> [Movie] {
        let request = SavedMovieEntity.fetchRequest()
        let entities = try viewContext.fetch(request)
        return entities.compactMap{$0.toMovie()}
    }
    
    func saveMovieEntities(movies: [Movie]) {
        let _ = movies.compactMap{$0.toMovieEntity(context: viewContext)}
        saveContext()
    }
    
    func fetchIntialMovies() throws -> [Movie] {
        let request = MovieEntity.fetchRequest()
        let entities = try viewContext.fetch(request)
        return entities.compactMap{$0.toMovie()}
    }
    
    func isSaved(movieID: Int) -> Bool {
        let request = SavedMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieID)
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            print("Failed to check saved status: \(error)")
            return false
        }
    }
    
    func removeFromFavorites(movieID: Int) {
        let request = SavedMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieID)
        do {
            let results = try viewContext.fetch(request)
            for entity in results {
                viewContext.delete(entity)
            }
            saveContext()
        } catch {
            print("Failed to remove from favorites: \(error)")
        }
    }

    func createPreparedFetchResultsController() -> NSFetchedResultsController<SavedMovieEntity> {
        let savedMovieRequest = SavedMovieEntity.fetchRequest()
        savedMovieRequest.sortDescriptors = [NSSortDescriptor(key: "date_added", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: savedMovieRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func fetchSavedMovie(with movieId: Int) -> Movie? {
        let request = SavedMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        do {
            let result = try viewContext.fetch(request)
            return result.first?.toMovie()
        } catch {
            print("Failed to remove from favorites: \(error)")
        }
        return nil
    }
    
    func fetchMovieEntity(with movieId: Int) -> Movie? {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        do {
            let result = try viewContext.fetch(request)
            return result.first?.toMovie()
        } catch {
            print("Failed to remove from favorites: \(error)")
        }
        return nil
    }
    
    func deleteAllMoviesEntity() {
        let request = MovieEntity.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            for entity in result {
                viewContext.delete(entity)
            }
            saveContext()
        } catch {
            print("Failed to remove from favorites: \(error)")
        }
    }
}
