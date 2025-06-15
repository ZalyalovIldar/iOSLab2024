//
//  FilmDTO.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 26.12.2024.
//

import Foundation

struct FilmResponce: Codable {
    let results: [Film]
}

struct Film: Codable, Hashable {
    let id: Int
    let title: String
    let poster: Poster
    
    /// Ускорение работы Hashable тк при работе с applySnapshot'ом diffableDataSource'а было долгое ожидание (2.8 секунд)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Film, rhs: Film) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Poster: Codable, Hashable {
    let image: String
}
