//
//  WatchlistManager.swift
//  films
//
//  Created by Кирилл Титов on 15.01.2025.
//

import Foundation

class WatchlistManager {
    static let shared = WatchlistManager()
    
    private let watchlistKey = "watchlist_movies"
    private var watchlist: Set<Int> = []
    
    private init() {
        loadWatchlist()
    }
    
    private func loadWatchlist() {
        if let savedWatchlist = UserDefaults.standard.array(forKey: watchlistKey) as? [Int] {
            watchlist = Set(savedWatchlist)
        }
    }
    
    func updateWatchlist(_ validMovieIDs: [Int]) {
        UserDefaults.standard.set(validMovieIDs, forKey: watchlistKey)
    }

    
    private func saveWatchlist() {
        UserDefaults.standard.set(Array(watchlist), forKey: watchlistKey)
    }
    
    func addToWatchlist(movieID: Int) {
        watchlist.insert(movieID)
        saveWatchlist()
    }
    
    func removeFromWatchlist(movieID: Int) {
        watchlist.remove(movieID)
        saveWatchlist()
    }
    
    func isInWatchlist(movieID: Int) -> Bool {
        return watchlist.contains(movieID)
    }
    
    func getAllWatchlistMovies() -> [Int] {
        return Array(watchlist)
    }
}
