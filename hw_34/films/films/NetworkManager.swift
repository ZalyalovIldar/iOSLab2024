//
//  NetworkManager.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://kudago.com/public-api/v1.4/movies/"
    
    func fetchMovies(page: Int = 1) async throws -> [Movie] {
        let urlString = "\(baseURL)?page=\(page)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let movieResponse = try JSONDecoder().decode(MovieListResponse.self, from: data)
        return movieResponse.results
    }
    
    func fetchMovieDetails(movieID: Int, completion: @escaping (Movie?) -> Void) {
        let url = URL(string: "https://kudago.com/public-api/v1.4/movies/\(movieID)/")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching movie details: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(Movie.self, from: data)
                completion(movie)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }

    func fetchMovies(from url: String) async throws -> MovieListResponse {
            guard let url = URL(string: url) else {
                throw URLError(.badURL)
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MovieListResponse.self, from: data)
            return response
        }

}
