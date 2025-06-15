//
//  FilmDetailDataManager.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 27.12.2024.
//

import UIKit

class FilmDetailDataManager {
    
    private let userDefaults = UserDefaults.standard
    private let favouriteKey = "is_favourite_"
    private let coreDataManager = CoreDataManager.shared
    
    func isFavourite(filmTitle: String) -> Bool {
        userDefaults.bool(forKey: favouriteKey + filmTitle)
    }
    
    func getFilmImages(_ film: FilmWithInfo) -> [String] {
        film.images.map { $0.image }
    }

    func getTrailerLink(_ film: FilmWithInfo) -> String {
        film.trailerLink ?? ""
    }
    
    func getFavouriteButtonImage(for film: FilmWithInfo) -> UIImage {
        isFavourite(filmTitle: film.title) ? .bookmarkOrange : .bookmarkWhite
    }
    
    func switchFilmState(film: FilmWithInfo) {
        let film = mapToFavouriteFilm(film)
        
        let filmUniqKey = favouriteKey + film.title
        var updatedValue = userDefaults.bool(forKey: filmUniqKey)
        /// Changing tha value
        updatedValue.toggle()
        userDefaults.set(updatedValue, forKey: filmUniqKey)
        
        if isFavourite(filmTitle: film.title) {
            addFilmToFavourite(film)
        } else {
            deleteFilmFromFavourite(film)
        }
    }
    
    private func addFilmToFavourite(_ film: FavouriteFilm) {
        coreDataManager.saveFavouriteFilm(film: film)
    }
    
    private func deleteFilmFromFavourite(_ film: FavouriteFilm) {
        coreDataManager.removeFavouriteFilm(film: film)
    }
    
    private func mapToFavouriteFilm(_ film: FilmWithInfo) -> FavouriteFilm {
        FavouriteFilm(poster: Poster(image: film.poster.image),
                                          title: film.title,
                                          rating: film.rating ?? 0.0,
                                          year: Int16(film.year),
                                          runningTime: Int16(film.runningTime ?? 0),
                                          country: film.country)
    }
}
