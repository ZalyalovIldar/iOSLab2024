import Foundation
import CoreData

protocol UpdateBookmarkedMoviesDelegate: AnyObject {
    func updateBookmarkedMovies()
}

protocol UpdateTopMoviesCollectionViewDelegate: AnyObject {
    func updateCollectionView()
}

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private weak var bookmarkedMoviesDelegate: UpdateBookmarkedMoviesDelegate?
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {}
    
    func setDelegate(updateBookmarkedMoviesDelegate: UpdateBookmarkedMoviesDelegate) {
        self.bookmarkedMoviesDelegate = updateBookmarkedMoviesDelegate
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
    
    func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        do {
            return try viewContext.fetch(request).map { entity in
                Movie(
                    id: Int(entity.id),
                    title: entity.title ?? "error",
                    poster: Poster(image: entity.imagePath?.base64EncodedString() ?? "notFound")
                )
            }
        } catch {
            print("Error fetching movies: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveMovies(_ movies: [Movie]) {
        let context = backgroundContext
        let group = DispatchGroup()
        
        context.perform { [weak self] in
            guard let self else { return }
            
            movies.forEach { movie in
                let movieEntity = MovieEntity(context: context)
                movieEntity.id = Int64(movie.id)
                movieEntity.title = movie.title
                
                group.enter()
                Task {
                    if let movieImage = try? await ImageService.downloadImage(from: movie.poster.image) {
                        movieEntity.imagePath = movieImage.pngData()
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.save(context: context)
            }
        }
    }
    
    func fetchBookmarkedMovies() -> [BookmarkedMovie] {
        let request: NSFetchRequest<BookmarkedMovieEntity> = BookmarkedMovieEntity.fetchRequest()
        
        do {
            return try viewContext.fetch(request).map { entity in
                BookmarkedMovie(
                    poster: Poster(image: entity.imagePath?.base64EncodedString() ?? ""),
                    title: entity.title ?? "no title",
                    rating: entity.rating,
                    year: entity.year,
                    runningTime: entity.runningTime,
                    country: entity.country ?? "no country"
                )
            }
        } catch {
            print("Error fetching bookmarked movies: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveBookmarkedMovie(_ movie: BookmarkedMovie) {
        let context = backgroundContext
        let group = DispatchGroup()
        
        context.perform { [weak self] in
            guard let self else { return }
            
            let entity = BookmarkedMovieEntity(context: context)
            entity.title = movie.title
            entity.rating = movie.rating
            entity.country = movie.country
            entity.year = movie.year
            entity.runningTime = movie.runningTime
            
            group.enter()
            Task {
                if let image = try? await ImageService.downloadImage(from: movie.poster.image) {
                    entity.imagePath = image.pngData()
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.save(context: context) {
                    self.bookmarkedMoviesDelegate?.updateBookmarkedMovies()
                }
            }
        }
    }
    
    func removeBookmarkedMovie(_ film: BookmarkedMovie) {
        let context = backgroundContext
        
        context.perform { [weak self] in
            guard let self else { return }
            
            let request: NSFetchRequest<BookmarkedMovieEntity> = BookmarkedMovieEntity.fetchRequest()
            request.predicate = NSPredicate(format: "title == %@", film.title)
            
            do {
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    self.save(context: context) {
                        self.bookmarkedMoviesDelegate?.updateBookmarkedMovies()
                    }
                } else {
                    print("Bookmarked movie not found: \(film.title)")
                }
            } catch {
                print("Error fetching bookmarked movies to delete: \(error)")
            }
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieApplication")
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

