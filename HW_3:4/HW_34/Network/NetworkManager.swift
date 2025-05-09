//
//  NetworkManager.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import UIKit

class NetworkManager {
    
    private let session: URLSession
    private var jsonDecoder: JSONDecoder { JSONDecoder() }
    private let cityCache: NSCache<NSURL, NSData> = .init()
    private var filmsInCityCache: NSCache<NSURL, NSData> = .init()
    
    init(with configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func obtainFilms() async throws -> [Film] {
        guard let url = URL(string: URLs.obtainPlainFilms.description()) else { return [] }
        
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        
        let filmResponse = try? jsonDecoder.decode(FilmResponce.self, from: responseData.0)
        return filmResponse?.results ?? []
    }
    
    func obtainCities() async throws -> [City] {
        guard let url = URL(string: URLs.obtainCities.description()) else { return [] }
        
        if let cachedData = cityCache.object(forKey: url as NSURL) {
            return try jsonDecoder.decode([City].self, from: cachedData as Data)
        }
        
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)

        let cities = try? jsonDecoder.decode([City].self, from: responseData.0)
        
        if let cities = cities {
            let encodedData = try JSONEncoder().encode(cities)
            cityCache.setObject(encodedData as NSData, forKey: url as NSURL)
        }
        
        return cities ?? []
    }
    
    func obtainFilmsInSelectedCity(city: City) async throws -> [Film] {
        guard let url = URL(string: URLs.obtainFilmsInSelectedCity(city.slug).description()) else { return [] }
        
        if let cachedData = filmsInCityCache.object(forKey: url as NSURL) {
            return try jsonDecoder.decode([Film].self, from: cachedData as Data)
        }
        
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        
        let filmResponse = try? jsonDecoder.decode(FilmResponce.self, from: responseData.0)
        
        if let filmResponse = filmResponse?.results {
            let encodedData = try JSONEncoder().encode(filmResponse)
            filmsInCityCache.setObject(encodedData as NSData, forKey: url as NSURL)
        }
        
        return filmResponse?.results ?? []
    }
    
    func getDetailAboutFilm(withId id: Int) async throws -> FilmDetail? {
        guard let url = URL(string: URLs.getDetailFilmById(id).description()) else { return nil }
        
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        
        let filmWithInfo = try? jsonDecoder.decode(FilmDetail.self, from: responseData.0)
        return filmWithInfo
    }
    
    func obtainFilmsOnPage(page: Int) async throws -> [Film] {
        guard let url = URL(string: URLs.getFilmsOnPage(page).description()) else { return [] }
        
        let urlRequest = URLRequest(url: url)
        let responseData = try await session.data(for: urlRequest)
        
        let filmResponse = try? jsonDecoder.decode(FilmResponce.self, from: responseData.0)
        return filmResponse?.results ?? []
    }
}
