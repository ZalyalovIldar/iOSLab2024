import Foundation
import CoreData

class MainScreenDataManager {
    
    private(set) var currentPage: Int = 1
    private let networkManager = NetworkManager(with: .default)
    private let coreDataManager = CoreDataManager.shared
    private let userDefaults = UserDefaults.standard
    private let loadDataKey = "did_load_data"
    
    func didLoadData() -> Bool { userDefaults.bool(forKey: loadDataKey) }
    func updateValueAfterSaving() { userDefaults.set(true, forKey: loadDataKey) }
    func updatePage() { currentPage += 1 }
    func backToDefaultPage() { currentPage = 1 }
    
    func obtainTopMovies() async -> [Movie] {
        if didLoadData() {
            let movies = coreDataManager.fetchMovies()
            return movies
        } else {
            do {
                let downloadedMovies = try await networkManager.obtainFilmsOnPage(page: 1)
                let filteredMovies = Array(downloadedMovies.sorted { $0.id > $1.id }.prefix(10))
                coreDataManager.saveMovies(filteredMovies)
                return filteredMovies
            } catch {
                print("Error obtaining top movies: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    func obtainMovies() async -> [Movie] {
        do {
            return try await networkManager.obtainFilmsOnPage(page: currentPage)
        } catch {
            print("Error of loading movies from network: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func obtainCities() async -> [City] {
        do {
            return try await networkManager.obtainCities()
        } catch {
            print("Error obtaining cities: \(error)")
            return []
        }
    }
    
    func obtainMoviesInSelectedCity(_ city: City) async -> [Movie] {
        do {
            return try await networkManager.obtainFilmsInSelectedCity(city: city)
        } catch {
            print("Error of obtaining movies in city: \(error.localizedDescription)")
            return []
        }
    }
    
    func getDetailAboutMovie(_ id: Int) async -> MovieWithInfo? {
        do {
            return try await networkManager.getDetailAboutFilm(withId: id)
        } catch {
            print("Error of obtaining movies detail info: \(error.localizedDescription)")
            return nil
        }
    }
}
