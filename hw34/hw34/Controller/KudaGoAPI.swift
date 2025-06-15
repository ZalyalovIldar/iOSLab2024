//
//  KudaGoAPI.swift
//  hw34
//
//  Created by Ильнур Салахов on 31.01.2025.
//


import Foundation

class KudaGoAPI {
    private let baseURL = "https://kudago.com/public-api/v1.4"

    func fetchMovies(completion: @escaping ([Movie]?) -> Void) {
        let urlString = "\(baseURL)/movies/"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let movies = try JSONDecoder().decode([Movie].self, from: data)
                completion(movies)
            } catch {
                completion(nil)
            }
        }.resume()
    }

    func fetchCities(completion: @escaping ([City]?) -> Void) {
        let urlString = "https://kudago.com/public-api/v1.2/locations/?lang=ru"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let cities = try JSONDecoder().decode([City].self, from: data)
                completion(cities)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
