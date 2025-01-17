//
//  MainScreenDataManager.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 13.01.25.
//

import Foundation
import CoreData

class MainScreenDataManager {
    
    private let coreDataManager = CoreDataManager.shared
    private let networkManager = NetworkManager(with: .default)
    private let userDefaults = UserDefaults.standard
    private let loadDataKey = "loadData"
    
    func didLoadData() -> Bool {
        return userDefaults.bool(forKey: loadDataKey)
    }
    
    func updateValueAfterSaving() {
        userDefaults.set(true, forKey: loadDataKey)
    }
    
    func obtainCoreDataFilms() -> [Film] {
        coreDataManager.obtainFilms().sorted { $1.title > $0.title }
    }
    
    func saveFilms(films: [Film]) {
        coreDataManager.saveFilms(films: films)
        self.updateValueAfterSaving()
    }
    
    func obtainFilmsInSelectedCity(city: City) async -> [Film] {
        do {
            return try await networkManager.obtainFilmsInSelectedCity(city: city)
        } catch {
            print("Erorr of obtaining films in selected city")
            return []
        }
    }
    
    func obtainFilms() async -> [Film] {
        do {
            return try await networkManager.obtainFilms()
        } catch {
            print("Erorr of obtaining films in selected city")
            return []
        }
    }
    
    func obtainCities() async -> [City] {
        do {
            return try await networkManager.obtainCities()
        } catch {
            print("Erorr of obtaining cities")
            return []
        }
    }
    
    func obtainFilmsOnPage(page: Int) async -> [Film] {
        do {
            return try await networkManager.obtainFilmsOnPage(page: page)
        } catch {
            print("Erorr of obtaining films on page \(page)")
            return []
        }
    }
    
    func getDetailAboutFilm(id: Int) async -> FilmDetail? {
        do {
            return try await networkManager.getDetailAboutFilm(withId: id)
        } catch {
            print("Erorr of obtaining datail about film with id: \(id)")
            return nil
        }
    }
}
