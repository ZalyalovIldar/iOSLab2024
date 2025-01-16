//
//  MainCoreDataManager.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() { }
    
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
    
    private func saveChanges(in context: NSManagedObjectContext) {
        do {
            if context.hasChanges {
                try context.save()
                
                viewContext.performAndWait {
                    do {
                        try viewContext.save()
                    } catch {
                        print("Failed to save main context: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Error saving background context: \(error.localizedDescription)")
        }
    }
    
    func obtainFilms() -> [Film] {
        let filmRequest = FilmEntity.fetchRequest()
        do {
            let filmEntities = try viewContext.fetch(filmRequest)
            let films: [Film] = filmEntities.map { filmEntity in
                Film(id: Int(filmEntity.id),
                     title: filmEntity.title ?? "",
                     poster: Poster(image: filmEntity.imagePath?.base64EncodedString() ?? ""))
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
        backgroundContext.perform {
            
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
            group.notify(queue: .main) { self.saveChanges(in: backgroundContext) }
        }
    }
    
    func obtainFavouriteFilms() -> [FavouriteFilm] {
        
        let fetchRequest = FavouriteFilmEntity.fetchRequest()
        do {
            let favouriteFilmEntities = try viewContext.fetch(fetchRequest)
            let favouriteFilms = favouriteFilmEntities.map { favouriteFilmEntity in
                
                let favouriteFilm = FavouriteFilm(poster: Poster(image: favouriteFilmEntity.imagePath?.base64EncodedString() ?? ""),
                                                  title: favouriteFilmEntity.title ?? "no title",
                                                  rating: favouriteFilmEntity.rating,
                                                  year: favouriteFilmEntity.year,
                                                  runningTime: favouriteFilmEntity.runningTime,
                                                  country: favouriteFilmEntity.country ?? "no country")
                return favouriteFilm
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
        backgroundContext.perform {
            
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
            
            group.notify(queue: .main) { self.saveChanges(in: backgroundContext) }
        }
    }
    
    func removeFavouriteFilm(film: FavouriteFilm) {
        
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            
            let fetchRequest = FavouriteFilmEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", film.title)
            
            do {
                let favouriteFilmEntities = try backgroundContext.fetch(fetchRequest)
                
                if let filmToDelete = favouriteFilmEntities.first {
                    backgroundContext.delete(filmToDelete)
                    
                    self.saveChanges(in: backgroundContext)
                } else {
                    print("Film with title '\(film.title)' not found in favourites")
                }
            } catch {
                print("Error fetching film to delete: \(error)")
            }
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HW_34")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
