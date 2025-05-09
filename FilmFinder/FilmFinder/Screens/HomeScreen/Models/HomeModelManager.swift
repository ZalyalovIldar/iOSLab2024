//
//  HomeModelManager.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import Foundation
import UIKit

import Foundation
import UIKit

import Foundation
import UIKit

class HomeModelManager {
    private let textFieldPlaceholder = "Поиск"
    private let textFieldIcon = UIImage(resource: .search)
    private let textNavigationBar = "Что вы хотите посмотреть?"
    private let alertTitle = "Такого фильма не существует в нашем приложении"
    private let alertMessage = "Извините пожалуйста"
    
    private let coreDataManager = CoreDataManager.shared
    private var userDefaults: UserDefaults
    private var keyUserDefaults = "CoreDataDidLoad"
    private let networkManager = NetworkManager(sessionConfiguration: .default)
    var nextPage = 2
    var countMovies: Int = 0
    
    private lazy var allMovies: [Movie] = {
        var movies: [Movie] = []
        let group = DispatchGroup()
        
        group.enter()
        Task {
            do {
                movies = try await networkManager.obtainMovies(page: 1)
                countMovies = movies.count
            } catch {
                print("Error when obtaining movies: \(error)")
            }
            group.leave()
        }
        
        group.wait()
        return movies
    }()
    
    private lazy var currentMovies: [Movie] = {
        let movies = allMovies
        return movies
    }()
    
    private lazy var cities: [City] = {
        var cities: [City] = []
        let group = DispatchGroup()
        
        group.enter()
        Task {
            do {
                cities = try await networkManager.obtainCities()
            } catch {
                print("Error when obtaining cities: \(error)")
            }
            group.leave()
        }
        
        group.wait()
        return cities
    }()
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    private func didLoad() -> Bool {
        userDefaults.bool(forKey: keyUserDefaults)
    }
    
    func obtainTopMovies() -> [Movie] {
        if didLoad() {
            return coreDataManager.obtainTopMovies()
        } else {
            let topMovies = Array(allMovies.shuffled().prefix(10))
            userDefaults.set(true, forKey: keyUserDefaults)
            coreDataManager.saveTopMovies(movies: topMovies)
            return topMovies
        }
    }

    func obtainAllMovies() -> [Movie] {
        return allMovies
    }
    
    func obtainCurrentMovies() -> [Movie] {
        return currentMovies
    }

    func obtainAllCities() -> [City] {
        return cities
    }

    func obtainMovies(forCity city: City) async -> [Movie] {
        do {
            return try await networkManager.obtainMovies(forCity: city.slug)
        } catch {
            print("Error obtaining movies for city \(city.name): \(error)")
            return []
        }
    }
    
    func obtainNewPageMovies() async -> [Movie] {
        do {
            let newMovies = try await networkManager.obtainMovies(page: nextPage)
            self.nextPage += 1
            self.currentMovies.append(contentsOf: newMovies)
            countMovies += newMovies.count
            return newMovies
        } catch {
            print("Error fetching movies: \(error)")
            return []
        }
    }

    func getTextFieldPlaceholder() -> String { textFieldPlaceholder }
    func getTextFieldIcon() -> UIImage { textFieldIcon }
    func getTextNavigationBar() -> String { textNavigationBar }
    func getAlertTitle() -> String { alertTitle }
    func getAlertMessage() -> String { alertMessage }
}
