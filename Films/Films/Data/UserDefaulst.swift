//
//  UserDefaulst.swift
//  Films
//
//  Created by Артур Мавликаев on 16.01.2025.
//

import Foundation

protocol DataManagerDelegate: AnyObject {
    func favoritesDidUpdate(newFavorites: [Int])
}

class DataManager {
    static let shared = DataManager()
    
    weak var delegate: DataManagerDelegate?
    
    private(set) var films: [Int] = []
    private let userdefaults: UserDefaults
    
    private init(userdefaults: UserDefaults = .standard) {
        self.userdefaults = userdefaults
        self.films = userdefaults.array(forKey: "films") as? [Int] ?? []
    }
    
    func saveFilm(filmId: Int) {
        films.append(filmId)
        userdefaults.set(films, forKey: "films")
        delegate?.favoritesDidUpdate(newFavorites: films)
    }
    
    func deleteFilm(fildId: Int) {
        if let index = films.firstIndex(of: fildId) {
            films.remove(at: index)
        }
        userdefaults.set(films, forKey: "films")
        delegate?.favoritesDidUpdate(newFavorites: films)
    }
    
    func getAllFilms() -> [Int] {
        return films
    }
}
