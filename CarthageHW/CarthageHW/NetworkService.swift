//
//  NetworkService.swift
//  CarthageHW
//
//  Created by Павел on 22.03.2025.
//

import Foundation
import SDWebImage
import UIKit

struct Cat: Decodable {
    let id: String
    let url: String
}

final class NetworkService {
    
    static let shared = NetworkService()
    private let session: URLSession = URLSession(configuration: .default)
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
        
    func obtainCats() async throws -> [Cat] {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10") else { return [] }
        let request = URLRequest(url: url)
        let responseData = try await session.data(for: request)
        let catsResponse = try jsonDecoder.decode([Cat].self, from: responseData.0)
        return catsResponse
    }
}
