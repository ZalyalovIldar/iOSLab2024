//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Anna on 16.01.2025.
//

import Foundation
import CoreData

protocol UpdateFavouriteFilmsDelegate: AnyObject {
    func updateFavouriteFilms()
}

protocol UpdatePopularFilmsCollectionViewDelegate: AnyObject {
    func updateCollectionView()
}

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private weak var favouriteFilmsDelegate: UpdateFavouriteFilmsDelegate?
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {}
    
    func setDelegate(updateFavouriteFilmsDelegate: UpdateFavouriteFilmsDelegate) {
        self.favouriteFilmsDelegate = updateFavouriteFilmsDelegate
    }
    
    func createFetchedResultsController() -> NSFetchedResultsController<BookmarkedMovieEntity> {
        let fetchRequest: NSFetchRequest<BookmarkedMovieEntity> = BookmarkedMovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    func fetchFilms() -> [Film] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        do {
            return try viewContext.fetch(request).map { entity in
                Film(
                    id: Int(entity.id),
                    title: entity.title ?? "error",
                    poster: Poster(image: entity.imagePath?.base64EncodedString() ?? "notFound")
                )
            }
        } catch {
            print("Error fetching films: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveFilms(_ films: [Film]) {
        let context = backgroundContext
        let group = DispatchGroup()
        
        context.perform { [weak self] in
            guard let self else { return }
            
            films.forEach { film in
                let filmEntity = MovieEntity(context: context)
                filmEntity.id = Int64(film.id)
                filmEntity.title = film.title
                
                group.enter()
                Task {
                    if let filmImage = try? await ImageService.downloadImage(from: film.poster.image) {
                        filmEntity.imagePath = filmImage.pngData()
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.save(context: context)
            }
        }
    }
    
    func fetchFavouriteFilms() -> [FavouriteFilm] {
        let request: NSFetchRequest<BookmarkedMovieEntity> = BookmarkedMovieEntity.fetchRequest()
        
        do {
            return try viewContext.fetch(request).map { entity in
                FavouriteFilm(
                    poster: Poster(image: entity.imagePath?.base64EncodedString() ?? ""),
                    title: entity.title ?? "no title",
                    rating: entity.rating,
                    year: entity.year,
                    runningTime: entity.runningTime,
                    country: entity.country ?? "no country"
                )
            }
        } catch {
            print("Error fetching favourite films: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveFavouriteFilm(_ film: FavouriteFilm) {
        let context = backgroundContext
        let group = DispatchGroup()
        
        context.perform { [weak self] in
            guard let self else { return }
            
            let entity = BookmarkedMovieEntity(context: context)
            entity.title = film.title
            entity.rating = film.rating
            entity.country = film.country
            entity.year = film.year
            entity.runningTime = film.runningTime
            
            group.enter()
            Task {
                if let image = try? await ImageService.downloadImage(from: film.poster.image) {
                    entity.imagePath = image.pngData()
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.save(context: context) {
                    self.favouriteFilmsDelegate?.updateFavouriteFilms()
                }
            }
        }
    }
    
    func removeFavouriteFilm(_ film: FavouriteFilm) {
        let context = backgroundContext
        
        context.perform { [weak self] in
            guard let self else { return }
            
            let request: NSFetchRequest<BookmarkedMovieEntity> = BookmarkedMovieEntity.fetchRequest()
            request.predicate = NSPredicate(format: "title == %@", film.title)
            
            do {
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    self.save(context: context) {
                        self.favouriteFilmsDelegate?.updateFavouriteFilms()
                    }
                } else {
                    print("Favourite film not found: \(film.title)")
                }
            } catch {
                print("Error fetching favourite film to delete: \(error)")
            }
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "cinemaAppNetworkRequest")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private func save(context: NSManagedObjectContext, completion: (() -> Void)? = nil) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                    completion?()
                } catch {
                    print("Error saving context: \(error.localizedDescription)")
                }
            }
        }
    }
}
