//
//  URL's.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 12.01.25.
//

import Foundation

enum URLs {
    case obtainPlainFilms
    case obtainCities
    case obtainFilmsInSelectedCity(String)
    case getDetailFilmById(Int)
    case getFilmsOnPage(Int)
    
    func description() -> String {
        switch self {
        case .obtainPlainFilms:
            return "https://kudago.com/public-api/v1.4/movies/"
        case .obtainCities:
            return "https://kudago.com/public-api/v1.2/locations/?lang=ru"
        case .obtainFilmsInSelectedCity(let slug):
            return "https://kudago.com/public-api/v1.4/movies/?location=\(slug)"
        case .getDetailFilmById(let id):
            return "https://kudago.com/public-api/v1.4/movies/\(id)/"
        case .getFilmsOnPage(let page):
            return "https://kudago.com/public-api/v1.4/movies/?page=\(page)"
        }
    }
}
