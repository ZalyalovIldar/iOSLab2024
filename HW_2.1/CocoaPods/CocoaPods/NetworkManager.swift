//
//  NetworkManager.swift
//  CocoaPods
//
//  Created by Терёхин Иван on 19.03.2025.
//

import Foundation
import Alamofire

struct City: Decodable {
    let slug: String
    let name: String
}

enum NetworkError: Error {
    case BadRequest
}


class NetworkManager {
    static let shared = NetworkManager(); private init() { }
    
    private let requestCities = "https://kudago.com/public-api/v1.2/locations/?lang=ru"
    private let decoder = JSONDecoder()
    
    //MARK: загрузка данных с api через библиотеку Alamofire
    func getCities(completion: @escaping (Result<[City], Error>) -> ()) {
        AF.request(requestCities)
            .validate()
            .response { responce in
                guard let data = responce.data else {
                    if let error = responce.error {
                        completion(.failure(error))
                    }
                    return
                }
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let cityResult = try? self.decoder.decode([City].self, from: data) else {
                    completion(.failure(NetworkError.BadRequest))
                    return
                }
                completion(.success(cityResult))
        }
    }
}
