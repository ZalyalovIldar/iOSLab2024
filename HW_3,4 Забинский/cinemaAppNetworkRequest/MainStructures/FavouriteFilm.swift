//
//  FavouriteFilm.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 28.12.2024.
//

import Foundation

struct FavouriteFilm: Codable, Hashable {
    
    let poster: Poster
    let title: String
    let rating: Double
    let year: Int16
    let runningTime: Int16
    let country: String
}
