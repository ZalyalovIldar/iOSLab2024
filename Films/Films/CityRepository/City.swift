//
//  City.swift
//  Films
//
//  Created by Артур Мавликаев on 12.01.2025.
//

import Foundation
final class City: Codable {
    static let shared = City()

    private var baseURL = "https://kudago.com/public-api/v1.2/locations/?lang=ru"
    private(set) var cities: [CityModel] = []

    private init() {}
    func fetchCities(completion: @escaping (Result<[CityModel], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let cities = try JSONDecoder().decode([CityModel].self, from: data)
                DispatchQueue.main.async {
                    self?.cities = cities
                    completion(.success(cities))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
