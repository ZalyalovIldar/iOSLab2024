//
//  FilmRepository.swift
//  Films
//
//  Created by Артур Мавликаев on 10.01.2025.
//
import Foundation
final class FilmsRepository {
    static let shared = FilmsRepository()

    private let baseURL = "https://kudago.com/public-api/v1.4/movies"
    private let filmDetailBaseURL = "https://kudago.com/public-api/v1.4/movies/"
    private(set) var films: [Film] = []

    private init() {}

    func fetchFilms(completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/?page=\(Int.random(in: 1...289))") else {
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
                let response = try JSONDecoder().decode(FilmsResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.films = response.results
                    completion(.success(response.results))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchFilmDetails(filmID: Int, completion: @escaping (Result<FilmDetail, Error>) -> Void) {
        let urlString = "\(filmDetailBaseURL)\(filmID)/"
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let filmDetail = try JSONDecoder().decode(FilmDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(filmDetail))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func fetchFilms(by location: String,
                    page: Int = 1,
                    pageSize: Int = 15,
                    completion: @escaping (Result<FilmsResponse, Error>) -> Void) {
        
        let urlString = "https://kudago.com/public-api/v1.4/movies/?location=\(location)&page=\(page)&page_size=\(pageSize)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(FilmsResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

