//
//  FilmDetailDataManager.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 14.01.25.
//

import Foundation

class FilmDetailDataManager {
    
    private let userDefaults = UserDefaults.standard
    private let favouriteKey = "IsFavouriteFilm"
    
    func convertToFavouriteFilm(filmEntity film: FilmDetail) -> FavouriteFilm {
         FavouriteFilm(poster: Poster(image: film.poster.image),
                                          title: film.title,
                                          rating: film.rating ?? 0.0,
                                          year: Int16(film.year),
                                          runningTime: Int16(film.runningTime ?? 0),
                                          country: film.country)
    }
    
    func updateState(filmTitle: String) {
        let filmKey = favouriteKey + filmTitle
        if userDefaults.bool(forKey: filmKey) {
            userDefaults.set(false, forKey: filmKey)
        } else {
            userDefaults.set(true, forKey: filmKey)
        }
    }
    
    func isFavourite(filmTitle: String) -> Bool {
        userDefaults.bool(forKey: favouriteKey + filmTitle)
    }
}
