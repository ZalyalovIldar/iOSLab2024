import Foundation

class NetworkingManager {
    
    
    private let session: URLSession
    private lazy var jsonDecoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    
    init(with configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    public func obtainMovies(_ page: Int) async throws -> [Movie] {
        
        guard let url = URL(string: URLManager.obtainURLMoviesAtPage(page)) else { return [] }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        
        return try jsonDecoder.decode(MovieResponse.self, from: responceData.0).results
        
    }
    
    public func obtaindMoviesDetailById(_ id: Int) async throws -> MovieDetail? {
        guard let url = URL(string: URLManager.obtainURLMoviesById(id)) else { return nil }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        let movie = try jsonDecoder.decode(MovieDetail.self, from: responceData.0)
        
        return try jsonDecoder.decode(MovieDetail.self, from: responceData.0)
    }
    
    public func obtainCities() async throws -> [City] {
        guard let url = URL(string: URLManager.obtainURLCities()) else { return [] }
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        
        return try jsonDecoder.decode([City].self, from: responceData.0)
    }
    
    func obtainFilmsByCity(citySlug: String, page: Int) async throws -> [Movie] {
        guard let url = URL(string: URLManager.obtainMoviesByCity(citySlug: citySlug, page: page))
        else { return [] }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
    
        return try jsonDecoder.decode(MovieResponse.self, from: responceData.0).results
                
    }
    
    
}
