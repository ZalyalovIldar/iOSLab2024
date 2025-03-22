//
//  NetworkManager.swift
//  CocoaPods
//
//  Created by Damir Rakhmatullin on 22.03.25.
//
import Alamofire
import SwiftyJSON

class NetworkManager {
    private var cache: NSCache<NSString, NSData> = .init()
    
    func getRandomFoxImageUrl() async throws -> String {
            return try await withCheckedThrowingContinuation { continuation in
                AF.request("https://randomfox.ca/floof/?utm_source=JSON%20API%20App&utm_medium=referral&utm_campaign=RandomFox&utm_term=RandomFox", method: .get)
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let imageUrl = JSON(value)["image"].stringValue
                            continuation.resume(returning: imageUrl)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
            }
        }

    func fetchRandomFoxImage(url: String) async throws -> Data {
        if let data = cache.object(forKey: url as NSString) {
                    return data as Data
                } else {
                    let data = try await AF.request(url, method: .get).serializingData().value
                    cache.setObject(data as NSData, forKey: url as NSString)
                    return data
                }
    }
}
        
        // Automatic String to URL conversion, Swift concurrency support, and automatic retry.

