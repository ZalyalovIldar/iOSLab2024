//
//  MainResponse.swift
//  Movies
//
//  Created by Павел Калинин on 22.12.2024.
//

struct MainResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Movie]
}
