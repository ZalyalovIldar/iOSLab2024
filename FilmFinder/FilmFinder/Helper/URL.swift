//
//  URL.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import Foundation

enum MyURL {
    case listMovies(page: Int)
    case detailInfoMovie(id: Int)
    case listCity
    case selectedCity(city: String)
    
    var urlString: String {
        switch self {
        case .listMovies(let page): return "https://kudago.com/public-api/v1.4/movies/?page=\(page)"
        case .listCity: return "https://kudago.com/public-api/v1.2/locations/?lang=ru"
        case .detailInfoMovie(let id):
            return "https://kudago.com/public-api/v1.4/movies/\(id)/"
        case .selectedCity(let city):
            return "https://kudago.com/public-api/v1.4/movies/?location=\(city)"
        }
    }
}
