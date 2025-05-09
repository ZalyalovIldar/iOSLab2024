//
//  CoreDataManager.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 11.01.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    var backgroundContext: NSManagedObjectContext { persistentContainer.newBackgroundContext() }
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FilmFinder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func obtainTopMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest<TopMovieEntity> = TopMovieEntity.fetchRequest()
        do {
            let topMovies = try viewContext.fetch(fetchRequest)
            let movies = topMovies.map { topMovies in
                Movie(
                    id: Int(topMovies.movieId),
                    title: "",
                    poster: Poster(image: ""),
                    dataImage: topMovies.poster)
            }
            return movies
        } catch {
            print("Failed to fetch top movies: \(error.localizedDescription)")
            return []
        }
    }
    
    func toggleFavoriteMovie(detailMovie: DetailMovie) async {
        let backgroundContext = backgroundContext

        let isFavorite = existsInFavorites(movieId: detailMovie.id)

        if isFavorite {
            await backgroundContext.perform { [weak self] in
                guard let self = self else { return }
                let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "movieId == %d", detailMovie.id)
                do {
                    let existingMovies = try backgroundContext.fetch(fetchRequest)
                    if let existingMovie = existingMovies.first {
                        let objectID = existingMovie.objectID
                        backgroundContext.delete(existingMovie)
                        
                        try backgroundContext.save()
                        self.viewContext.performAndWait {
                            let object = self.viewContext.object(with: objectID)
                            self.viewContext.refresh(object, mergeChanges: true)
                            try? self.viewContext.save()
                        }
                    }
                } catch {
                    print("Failed to delete movie: \(error.localizedDescription)")
                }
            }
        } else {
            let imageData: Data?
            do {
                imageData = try await ImageService.downloadImageData(from: detailMovie.poster.image)
            } catch {
                print("Failed to download image: \(error.localizedDescription)")
                imageData = nil
            }
            
            await backgroundContext.perform { [weak self] in
                guard let self = self else { return }
                let movieEntity = MovieEntity(context: backgroundContext)
                movieEntity.movieId = Int16(detailMovie.id)
                movieEntity.genre = detailMovie.genres.first?.name
                movieEntity.rating = detailMovie.rating ?? 0.0
                movieEntity.text = detailMovie.text
                movieEntity.title = detailMovie.title
                movieEntity.year = Int16(detailMovie.year)
                movieEntity.runningTime = Int16(detailMovie.runningTime ?? 0)
                movieEntity.poster = imageData
                
                let objectID = movieEntity.objectID
                do {
                    try backgroundContext.save()
                    self.viewContext.performAndWait {
                        let object = self.viewContext.object(with: objectID)
                        self.viewContext.refresh(object, mergeChanges: true)
                        try? self.viewContext.save()
                    }
                } catch {
                    print("Failed to save movie: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getDetailMovie(movieId: Int) -> DetailMovie? {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieId == %d", movieId)
        do {
            let movieEntity = try backgroundContext.fetch(fetchRequest)
            if let movie = movieEntity.first {
                let detailMovie = DetailMovie(
                    id: Int(movie.movieId),
                    title: movie.title!,
                    text: movie.text!,
                    runningTime: Int(movie.runningTime),
                    rating: movie.rating,
                    year: Int(movie.year),
                    genres: [Genre(name: movie.genre!)],
                    stars: "",
                    director: "",
                    writer: "",
                    trailer: "",
                    images: [],
                    poster: Poster(image: ""),
                    dataPoster: movie.poster)
                return detailMovie
            }
        } catch {
            print("Failed to fetch or save favorite movie: \(error.localizedDescription)")
        }
        return nil
    }
    
    func existsInFavorites(movieId: Int) -> Bool {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieId == %d", movieId)
        do {
            return try backgroundContext.count(for: fetchRequest) > 0
        } catch {
            print("Failed to check if movie exists in favorites: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteAllEntities(entityName: String) {

        let context = viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All \(entityName) entities were successfully deleted.")

        } catch {
            print("Failed to delete all \(entityName) entities: \(error.localizedDescription)")
        }
    }
    
    func createFetchResultController() -> NSFetchedResultsController<MovieEntity> {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchResultController
    }

    // MARK: - Core Data Saving support

    func saveTopMovies(movies: [Movie]) {
        let backgroundContext = backgroundContext
        let dispatchGroup = DispatchGroup()
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            for movie in movies {
                let movieEntity = TopMovieEntity(context: backgroundContext)
                movieEntity.movieId = Int16(movie.id)
                dispatchGroup.enter()
                Task {
                    do {
                        let data = try await ImageService.downloadImageData(from: movie.poster.image)
                        movieEntity.poster = data
                    }
                    catch {
                        print("Failed to download image: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                do {
                    try backgroundContext.save()
                    self.viewContext.performAndWait {
                        do {
                            try self.viewContext.save()
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
}
