import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager();  private init() {  }
    
    var viewContext: NSManagedObjectContext  {
        return persistentContainer.viewContext
    }
    
    func obtainMovies()  throws -> [Movie]  {
        let movieRequest = MovieEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        movieRequest.sortDescriptors = [sortDescriptor]
        do {
            let movieEntites = try viewContext.fetch(movieRequest)
            let moviesDto = movieEntites.map({ movieEntity in
                Movie(id: movieEntity.id,
                      title: movieEntity.title ?? "Not found",
                      poster: Poster(image: movieEntity.poster ?? ""))
            })
            return moviesDto
        } catch {
            print("Failed to fetch movies: \(error)")
            throw error
        }
    }
    
    func obtainMoviesByTitle(title: String) throws -> Movie? {
        let request = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format:"title==[cd] %@" , title)
        do {
            let result = try viewContext.fetch(request)
            let movie = result.map { MovieEntity in
                Movie(id: MovieEntity.id,
                      title: MovieEntity.title ?? "Not found",
                      poster: Poster(image: MovieEntity.poster ?? "")
            )}
            return movie.first
        } catch {
            print("Failed to fetch movie by title")
            return nil
        }
    }
    
    func saveFavoriteMovies(_ movie: MovieDetail) {
        let fetchRequest = MovieFavoriteEntites.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        do {
            let existingMovies = try viewContext.fetch(fetchRequest)
            if existingMovies.isEmpty {
                let favoriteMovieEntity = MovieFavoriteEntites(context: viewContext)
                favoriteMovieEntity.id = Int64(movie.id)
                favoriteMovieEntity.title = movie.title
                favoriteMovieEntity.poster = movie.poster.image
                favoriteMovieEntity.raiting = movie.raiting ?? 0
                favoriteMovieEntity.duration = movie.duration
                favoriteMovieEntity.genre = movie.genres.map { $0.name }.joined(separator: ", ")
                favoriteMovieEntity.year = movie.year
            }
        } catch {
            print("Error checking for existing movie: \(error)")
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving viewContext: \(error)")
        }
    }
    
    func obtainFavoriteMovies() throws -> [MovieFavoriteEntites] {
        let request = MovieFavoriteEntites.fetchRequest()
        do {
            deleteAllFavoriteMovie()
            return try viewContext.fetch(request)

        } catch {
            print("Failed to fetch favorite movies: \(error)")
            throw error
        }
    }
    
    func removeFavoriteMovies(byId id: Int) {
        let request = MovieFavoriteEntites.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let movies = try viewContext.fetch(request)
            if let removeMovies = movies.first {
                viewContext.delete(removeMovies)
                try viewContext.save()
            }
        } catch {
            print("Failed to delete favorite movies: \(error)")
        }
    }
        
    func saveMovie(_ movies: [Movie]) {
        for movie in movies {
            let fetchRequest = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

            do {
                let existingMovies = try viewContext.fetch(fetchRequest)
                if existingMovies.isEmpty {
                    let movieEntity = MovieEntity(context: viewContext)
                    movieEntity.id = movie.id
                    movieEntity.title = movie.title
                    movieEntity.poster = movie.poster.image
                } else {
                    print("Movie with ID \(movie.id) already exists")
                }
            } catch {
                print("Error checking for existing movie: \(error)")
            }
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving viewContext: \(error)")
        }
    }

    
    func deleteAllMovie() {
        let movieRequest = MovieEntity.fetchRequest()
        
        do {
            let movies = try viewContext.fetch(movieRequest)
            
            for movie in movies {
                viewContext.delete(movie)
            }
            
            do {
               try viewContext.save()
            } catch {
                print("Error save context: \(error)")
            }
            
        } catch {
            print("Error delete movies \(error)")
        }
    }
    
    func deleteAllFavoriteMovie() {
        let movieRequest = MovieFavoriteEntites.fetchRequest()
        
        do {
            let movies = try viewContext.fetch(movieRequest)
            
            for movie in movies {
                viewContext.delete(movie)
            }
            
            do {
               try viewContext.save()
            } catch {
                print("Error save context: \(error)")
            }
            
        } catch {
            print("Error delete movies \(error)")
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
