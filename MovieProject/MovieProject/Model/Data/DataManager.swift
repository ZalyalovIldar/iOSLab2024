import Foundation
import UIKit
class DataManager {
    private let networkManager = NetworkingManager(with: .default)
    private let coreDataManager = CoreDataManager.shared
    
    func obtainAndCheckMovies(page: Int) async -> [Movie] {
        do {
            let localMovies = try coreDataManager.obtainMovies()
            if (!localMovies.isEmpty) {
                return localMovies
            }
            let movies = try await networkManager.obtainMovies(page)
            coreDataManager.saveMovie(movies)
            return movies
        } catch {
            print("Failed to obtainMovies: \(NetworkError.badRequest)")
            return []
        }
    }
 
    func getRandomMovies(page: Int) async -> [Movie] {
        let movies = await obtainAndCheckMovies(page: page)
        return movies.shuffled().prefix(10).map { $0 }
    }
    
    func getCities() async -> [City] {
        do {
            return try await networkManager.obtainCities()
        } catch {
            print("Failed get cities = \(NetworkError.badRequest)")
            return []
        }
    }
    
    func getDetailMovie(_ id: Int) async -> MovieDetail? {
        do {
            return try await networkManager.obtaindMoviesDetailById(id)
        } catch {
            print("Failed get detail movies = \(NetworkError.badRequest)")
            return nil
            
        }
    }
    
    func getMovieByTitle(_ title: String) -> Movie? {
        do {
            return try coreDataManager.obtainMoviesByTitle(title: title)
        } catch {
            print("Failed get movie by title")
            return nil
        }
    }
    
    func obtainMoviesByCity(citySlug: String, page: Int) async -> [Movie]? {
        do {
            let movies = try await networkManager.obtainFilmsByCity(citySlug: citySlug, page: page)
            return movies
        } catch {
            print("Failed get movie by city slug")
            return nil
        }
    }
    
    func saveFavoriteMovies(detailMovies: MovieDetail) {
        coreDataManager.saveFavoriteMovies(detailMovies)
    }
    
    func getFavoriteMovies() -> [MovieFavoriteEntites]? {
        do {
            return try coreDataManager.obtainFavoriteMovies()
        } catch {
            print("Failed get favorite movies: \(error)")
            return nil
        }
    }
    
    func deleteFavoriteMovies(by id: Int) {
        coreDataManager.removeFavoriteMovies(byId: id)
    }
}
