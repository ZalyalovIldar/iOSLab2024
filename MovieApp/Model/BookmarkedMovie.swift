//
//  FavouriteFilm.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//

import Foundation

struct BookmarkedMovie: Codable, Hashable {
    
    let poster: Poster
    let title: String
    let rating: Double
    let year: Int16
    let runningTime: Int16
    let country: String
}
