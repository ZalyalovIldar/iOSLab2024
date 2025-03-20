//
//  NetworkManagerWithAlamofire.swift
//  AlamofireProject
//
//  Created by Тагир Файрушин on 19.03.2025.
//

import Foundation
import Alamofire

class NetworkManagerWithAlamofire {
    static var shared: NetworkManagerWithAlamofire = NetworkManagerWithAlamofire()
    private var cache: NSCache<NSString, NSData> = .init()
    
    private init() { }
    
    func fetchDogImage(statusCode: Int) async throws -> Data {
        let url = "https://http.dog/\(statusCode).jpg"
        if let data = cache.object(forKey: url as NSString) {
            return data as Data
        } else {
            let data = try await AF.request(url, method: .get).serializingData().value
            cache.setObject(data as NSData, forKey: url as NSString)
            return data
        }
    }
}
