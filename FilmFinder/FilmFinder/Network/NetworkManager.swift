//
//  NetworkManager.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 31.12.2024.
//

import Foundation

class NetworkManager {
    private var session: URLSession
    
    private var cache: NSCache<NSURL, NSData> = .init()
    
    private var jsonDecoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func obtainMovies(page: Int) async throws -> [Movie] {
        guard let url = URL(string: MyURL.listMovies(page: page).urlString) else { return [] }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        let resultMovies = try jsonDecoder.decode(MovieResponce.self, from: responceData.0)
        
        return resultMovies.results
    }
    
    func obtainCities() async throws -> [City] {
        guard let url = URL(string: MyURL.listCity.urlString) else { return [] }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        let resultCities = try jsonDecoder.decode([City].self, from: responceData.0)
        
        return resultCities
    }
    
    func obtainMovies(forCity selectedSlug: String) async throws -> [Movie] {
        guard let url = URL(string: MyURL.selectedCity(city: selectedSlug).urlString) else { return [] }
        
        if let data = cache.object(forKey: url as NSURL) {
            let responceMovie = try jsonDecoder.decode(MovieResponce.self, from: data as Data)
            return responceMovie.results
        }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        let responceMovie = try jsonDecoder.decode(MovieResponce.self, from: responceData.0)
        
        return responceMovie.results
    }
    
    func obtainDetailMovie(id: Int) async throws -> DetailMovie? {
        guard let url = URL(string: MyURL.detailInfoMovie(id: id).urlString) else { return nil }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        let responceDetailMovie = try jsonDecoder.decode(DetailMovie.self, from: responceData.0)
        return responceDetailMovie
    }
    
    func obtainAdditionallyDetailMovie(id: Int) async throws -> FavoriteMovieFromNetwork? {
        guard let url = URL(string: MyURL.detailInfoMovie(id: id).urlString) else { return nil }
        
        let urlRequest = URLRequest(url: url)
        
        let responceData = try await session.data(for: urlRequest)
        let responceFavoriteMovieFromNetwork = try jsonDecoder.decode(FavoriteMovieFromNetwork.self, from: responceData.0)
        return responceFavoriteMovieFromNetwork
    }
}
