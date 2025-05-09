//
//  NetworkManager.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 24.12.2024.
//

import Foundation

struct URLs {

    static func obtainFilmsOnPage(page: Int) -> String {
        "https://kudago.com/public-api/v1.4/movies/?page=\(page)"
    }
    static let obtainCities = "https://kudago.com/public-api/v1.2/locations/?lang=ru"
    static func obtainFilmsInSelectedCity(citySlug: String) -> String {
        return "https://kudago.com/public-api/v1.4/movies/?location=\(citySlug)"
    }
    static func getDetailAboutFilm(with id: Int) -> String {
        return "https://kudago.com/public-api/v1.4/movies/\(id)/"
    }
}

class NetworkManager {
    
    private let session: URLSession
    private lazy var jsonDecoder: JSONDecoder = { JSONDecoder() }()
    private var filmsInSelectedCity: NSCache<NSURL, NSData> = .init()
    
    init(with configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func obtainFilmsOnPage(page: Int) async throws -> [Film] {
        guard let url = URL(string: URLs.obtainFilmsOnPage(page: page)) else { return [] }
        
        let urlRequest = URLRequest(url: url)
        let responceData = try await session.data(for: urlRequest)
        
        let filmResponce = try? jsonDecoder.decode(FilmResponce.self, from: responceData.0)
        return filmResponce?.results ?? []
    }
    
    func obtainCities() async throws -> [City] {
        guard let url = URL(string: URLs.obtainCities) else { return [] }
        
        let urlRequest = URLRequest(url: url)
        let responceData = try await session.data(for: urlRequest)
        
        let cities = try jsonDecoder.decode([City].self, from: responceData.0)
        return cities
    }
    
    func obtainFilmsInSelectedCity(city: City) async throws -> [Film] {
        guard let url = URL(string: URLs.obtainFilmsInSelectedCity(citySlug: city.slug)) else { return [] }
        
        if let data = filmsInSelectedCity.object(forKey: url as NSURL) {
            let films = try jsonDecoder.decode(FilmResponce.self, from: data as Data)
            return films.results
        }
        
        let urlRequest = URLRequest(url: url)
        let responceData = try await session.data(for: urlRequest)
        filmsInSelectedCity.setObject(responceData.0 as NSData, forKey: url as NSURL)
        
        let filmResponce = try? jsonDecoder.decode(FilmResponce.self, from: responceData.0)
        return filmResponce?.results ?? []
    }
    
    func getDetailAboutFilm(withId id: Int) async throws -> FilmWithInfo? {
        guard let url = URL(string: URLs.getDetailAboutFilm(with: id)) else { return nil }
        
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        
        let filmWithInfo = try? jsonDecoder.decode(FilmWithInfo.self, from: responseData.0)
        return filmWithInfo
    }
}
