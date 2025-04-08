//
//  MainCoreDataManager.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 25.12.2024.
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
    
    private weak var favouriteFilmsDelegate: UpdateFavouriteFilmsDelegate?
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() { }
    
    func setDelegate(updateFavouriteFilmsDelegate: UpdateFavouriteFilmsDelegate) {
        self.favouriteFilmsDelegate = updateFavouriteFilmsDelegate
    }
    
    func createNSFetchedResultController() -> NSFetchedResultsController<FavouriteFilmEntity> {
        
        let favouriteFilmRequest = FavouriteFilmEntity.fetchRequest()
        favouriteFilmRequest.sortDescriptors = []
        
        let controller = NSFetchedResultsController(
            fetchRequest: favouriteFilmRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return controller
    }
    
    func obtainFilms() -> [Film] {
        
        let filmRequest = FilmEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        filmRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let filmEntities = try viewContext.fetch(filmRequest)
            let films: [Film] = filmEntities.map { filmEntity in
                Film(id: Int(filmEntity.id),
                    title: filmEntity.title ?? "error",
                    poster: Poster(image: filmEntity.imagePath?.base64EncodedString() ?? "notFound"))
            }
            return films
        } catch {
            print("Obtaining error: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveFilms(films: [Film]) {
        
        let backgroundContext = backgroundContext
        let group = DispatchGroup()
        backgroundContext.perform { [weak viewContext] in
            guard let viewContext else { return }
            
            for film in films {
                let filmEntity = FilmEntity(context: backgroundContext)
                filmEntity.id = Int64(film.id)
                filmEntity.title = film.title
                
                group.enter()
                Task {
                    let filmImage = try await ImageService.downloadImage(from: film.poster.image)
                    let imageData = filmImage?.pngData()
                    filmEntity.imagePath = imageData
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                do {
                    try backgroundContext.save()
                    viewContext.performAndWait {
                        do {
                            try viewContext.save()
                        } catch {
                            print("Error from saving in viewContext: \(error.localizedDescription)")
                        }
                    }
                } catch {
                    print("Error from saving in backgoundContext: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func obtainFavouriteFilms() -> [FavouriteFilm] {
        
        let fetchRequest = FavouriteFilmEntity.fetchRequest()
        do {
            let favouriteFilmEntities = try viewContext.fetch(fetchRequest)
            let favouriteFilms = favouriteFilmEntities.map { favouriteFilmEntity in
                FavouriteFilm(poster: Poster(image: favouriteFilmEntity.imagePath?.base64EncodedString() ?? ""),
                                                  title: favouriteFilmEntity.title ?? "no title",
                                                  rating: favouriteFilmEntity.rating,
                                                  year: favouriteFilmEntity.year,
                                                  runningTime: favouriteFilmEntity.runningTime,
                                                  country: favouriteFilmEntity.country ?? "no country")
            }
            return favouriteFilms
        } catch {
            print("Obtaining error: \(error.localizedDescription)")
        }
        return []
    }
    
    func saveFavouriteFilm(film: FavouriteFilm) {
        
        let backgroundContext = backgroundContext
        let group = DispatchGroup()
        backgroundContext.perform { [weak viewContext] in
            guard let viewContext else { return }
            
            let favouriteFilmEntity = FavouriteFilmEntity(context: backgroundContext)
            favouriteFilmEntity.title = film.title
            favouriteFilmEntity.rating = film.rating
            favouriteFilmEntity.country = film.country
            favouriteFilmEntity.year = film.year
            favouriteFilmEntity.runningTime = film.runningTime
            
            group.enter()
            Task {
                let image = try await ImageService.downloadImage(from: film.poster.image)
                let imageData = image?.pngData()
                favouriteFilmEntity.imagePath = imageData
                group.leave()
            }
            
            group.notify(queue: .main) {
                do {
                    try backgroundContext.save()
                    
                    viewContext.performAndWait { [weak self] in
                        guard let self else { return }
                        do {
                            try viewContext.save()
                            favouriteFilmsDelegate?.updateFavouriteFilms()
                        } catch {
                            print("Error saving to viewContext: \(error)")
                        }
                    }
                } catch {
                    print("Error from saving in backgoundContext: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeFavouriteFilm(film: FavouriteFilm) {
        
        let backgroundContext = backgroundContext
        backgroundContext.perform { [weak viewContext] in
            guard let viewContext else { return }
            
            let fetchRequest = FavouriteFilmEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", film.title)
            
            do {
                let favouriteFilmEntities = try backgroundContext.fetch(fetchRequest)
                
                if let filmToDelete = favouriteFilmEntities.first {
                    backgroundContext.delete(filmToDelete)
                    
                    do {
                        try backgroundContext.save()
                        
                        viewContext.performAndWait { [weak self] in
                            guard let self else { return }
                            do {
                                try viewContext.save()
                                favouriteFilmsDelegate?.updateFavouriteFilms()
                            } catch {
                                print("Error saving viewContext after delete: \(error)")
                            }
                        }
                    } catch {
                        print("Error saving backgroundContext after delete: \(error)")
                    }
                } else {
                    print("Film with title '\(film.title)' not found in favourites")
                }
            } catch {
                print("Error fetching film to delete: \(error)")
            }
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "cinemaAppNetworkRequest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
