//
//  MovieModels.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 31.12.2024.
//

import Foundation

struct Poster: Hashable, Codable {
    let image: String
}

struct Movie: Hashable, Codable {
    let id: Int
    let title: String
    let poster: Poster
    let dataImage: Data?
}

struct MovieResponce: Codable {
    let results: [Movie]
}

