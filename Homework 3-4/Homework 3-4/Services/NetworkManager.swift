import Foundation
import CoreData

final class NetworkManager {
    
    static let shared = NetworkManager(
        with: .default,
        context: CoreDataManager.shared.viewContext
    )
    
    let coreDataManager = CoreDataManager.shared
    
    private let session: URLSession
    private let context: NSManagedObjectContext
    
    private init(with configuration: URLSessionConfiguration, context: NSManagedObjectContext) {
        self.session = URLSession(configuration: configuration)
        self.context = context
    }
    
    @MainActor
    func obtainFilms(page: Int = 1) async throws -> FilmsResponse {
        let fetchRequest: NSFetchRequest<FilmsResponse> = FilmsResponse.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "page == %d", page)
        
        if let cachedResponse = try? context.fetch(fetchRequest).first {
            return cachedResponse
        }
        
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/?lang=en&page=\(page)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        let filmsResponseID = try coreDataManager.decodeInBackgroundContext(FilmsResponse.self, from: data)
        
        guard let decodedResponse = context.object(with: filmsResponseID) as? FilmsResponse else {
            throw NSError(domain: "NetworkManagerError", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Failed to cast FilmsResponse"
            ])
        }
        
        decodedResponse.page = Int16(page)
        try context.save()
        
        return decodedResponse
    }
    
    func obtainRandomFilms() async throws -> [Film] {
        let count: Int = 10
        let firstResponse = try await obtainFilms(page: 1)
                
        let filmsPerPage = firstResponse.results?.count ?? 1
        let totalFilms = firstResponse.count

        let totalPages = totalFilms > 0 && filmsPerPage > 0
            ? max(1, Int(ceil(Double(totalFilms) / Double(filmsPerPage))))
            : 1
                
        var selectedFilms: Set<Film> = []
        var visitedPages: Set<Int> = []
        
        while selectedFilms.count < count && visitedPages.count < totalPages {
            let remaining = count - selectedFilms.count
            let randomPage = Int.random(in: 1...totalPages)
            
            if visitedPages.contains(randomPage) { continue }
            
            visitedPages.insert(randomPage)
            let filmResponse = try await obtainFilms(page: randomPage)
            
            guard let availableFilms = filmResponse.results?.allObjects as? [Film],
                  !availableFilms.isEmpty
            else {
                continue
            }
                        
            let filmsToSelect = min(remaining, availableFilms.count)
            selectedFilms.formUnion(availableFilms.shuffled().prefix(filmsToSelect))
        }
        
        return Array(selectedFilms)
    }
    
    @MainActor
    func obtainFilmData(filmId: Int, for film: Film) async throws -> DetailedFilm {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/\(filmId)/?fields=title,body_text,genres,country,year,running_time,age_restriction,stars,director,trailer,images,poster,imdb_rating") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await session.data(from: url)
        
        let detailedFilmID = try coreDataManager.decodeInBackgroundContext(DetailedFilm.self, from: data)
        
        guard let detailedFilm = context.object(with: detailedFilmID) as? DetailedFilm else {
            throw NSError(domain: "NetworkManagerError", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Failed to cast DetailedFilm"
            ])
        }
        
        detailedFilm.film = film
        
        if context.hasChanges {
            try context.save()
        }
        
        return detailedFilm
    }
    
    private func clearOldFilms() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Film.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }
    
    @MainActor
    func fetchFavorites() -> [Film] {
        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavourite == true")
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites
        } catch {
            print("Failed to fetch favorite films: \(error)")
            return []
        }
    }
    
    @MainActor
    func obtainCities() async throws -> [City] {
        guard let url = URL(string: "https://kudago.com/public-api/v1.2/locations/?lang=ru") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        let cityIDs = try coreDataManager.decodeInBackgroundContextArray([City].self, from: data)
        
        let cities = cityIDs.compactMap { context.object(with: $0) as? City }
        
        return cities
    }
    
    @MainActor
    func obtainFilmForCities(for citySlug: String, page: Int = 1) async throws -> FilmsResponse {
                
        let urlString = "https://kudago.com/public-api/v1.4/movies/?lang=en&page=\(page)&location=\(citySlug)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)

        let jsonString = String(data: data, encoding: .utf8) ?? ""
        
        let filmsResponseID = try coreDataManager.decodeInBackgroundContext(FilmsResponse.self, from: data)
        
        guard let decodedResponse = context.object(with: filmsResponseID) as? FilmsResponse else {
            throw NSError(domain: "NetworkManagerError", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Failed to cast FilmsResponse"
            ])
        }
        
        decodedResponse.page = Int16(page)
        try context.save()

        return decodedResponse
    }
}
