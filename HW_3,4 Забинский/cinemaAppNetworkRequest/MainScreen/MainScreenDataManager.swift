//
//  MainScreenDataManager.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 24.12.2024.
//

import Foundation
import CoreData

class MainScreenDataManager {
    
    private(set) var currentPage: Int = 1
    private let networkManager = NetworkManager(with: .default)
    private let coreDataManager = CoreDataManager.shared
    private let userDefaults = UserDefaults.standard
    private let loadDataKey = "did_load_data"
    
    func didLoadData() -> Bool { userDefaults.bool(forKey: loadDataKey) }
    func updateValueAfterSaving() { userDefaults.set(true, forKey: loadDataKey) }
    func updatePage() { currentPage += 1 }
    func backToDefaultPage() { currentPage = 1 }
    
    func obtainPopularFilms() async -> [Film] {
        if didLoadData() {
            let films = coreDataManager.obtainFilms()
            return films
        } else {
            do {
                let downloadedFilms = try await networkManager.obtainFilmsOnPage(page: 1)
                let filteredFilms = Array(downloadedFilms.sorted { $0.id > $1.id }.prefix(10))
                coreDataManager.saveFilms(films: filteredFilms)
                return filteredFilms
            } catch {
                print("Error obtaining popular films: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    func obtainFilms() async -> [Film] {
        do {
            return try await networkManager.obtainFilmsOnPage(page: currentPage)
        } catch {
            print("Error of loading films from network: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func obtainCities() async -> [City] {
        do {
            return try await networkManager.obtainCities()
        } catch {
            print("Error obtaining cities: \(error)")
            return []
        }
    }
    
    func obtainFilmsInSelectedCity(_ city: City) async -> [Film] {
        do {
            return try await networkManager.obtainFilmsInSelectedCity(city: city)
        } catch {
            print("Error of obtaining films in city: \(error.localizedDescription)")
            return []
        }
    }
    
    func getDetailAboutFilm(_ id: Int) async -> FilmWithInfo? {
        do {
            return try await networkManager.getDetailAboutFilm(withId: id)
        } catch {
            print("Error of obtaining films detail info: \(error.localizedDescription)")
            return nil
        }
    }
}
