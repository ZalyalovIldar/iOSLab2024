//
//  URLManager.swift
//  MovieProject
import Foundation

struct URLManager {
    
    static func obtainURLMoviesInSelectedCity(_ cityName: String) -> String {
        return "https://kudago.com/public-api/v1.4/movies/?location=\(cityName)"
    }
    
    static func obtainURLCities() -> String {
        return "https://kudago.com/public-api/v1.2/locations/?lang=ru"
    }
    
    static func obtainURLMoviesById(_ id: Int) -> String {
        return "https://kudago.com/public-api/v1.4/movies/\(id)/"
    }
    
    
    static func obtainURLMoviesAtPage(_ page: Int) -> String {
        return "https://kudago.com/public-api/v1.4/movies/?page=\(page)"
    }
    
    static func obtainMoviesByCity(citySlug: String, page: Int) -> String {
        return "https://kudago.com/public-api/v1.4/movies/?location=\(citySlug)&page=\(page)"
    }
}
