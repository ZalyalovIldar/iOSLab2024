//
//  NetworkService.swift
//  SwiftyJsonHW
//
//  Created by Павел on 21.03.2025.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func obtainCats(completion: @escaping ([String]) -> Void) {
        AF.request("https://api.thecatapi.com/v1/images/search?limit=10", method: .get)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = try! JSON(data: data)
                    let photosUrls = json.arrayValue.compactMap({ $0["url"].stringValue })
                    completion(photosUrls)
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
    }
    
    func getPhotosFromURL(completion: @escaping ([UIImage]) -> Void) {
        obtainCats { photoUrls in
            var photos: [UIImage] = []
            let group = DispatchGroup()
            
            for photoString in photoUrls {
                group.enter()
                Task {
                    if let photo = try? await ImageService.downloadImage(by: photoString) {
                        photos.append(photo)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(photos)
            }
        }
        
    }
    
    class ImageService {
        
        static let cache: NSCache<NSURL, NSData> = NSCache()
        
        static let imageSession: URLSession = {
            let session = URLSession(configuration: .default)
            return session
        }()
        
        static func downloadImage(by stringURL: String) async throws -> UIImage? {
            guard let url = URL(string: stringURL) else { return nil }
            
            if let imageData = cache.object(forKey: url as NSURL) {
                return UIImage(data: imageData as Data)
            }
            
            let imageResponse = try await imageSession.data(from: url)
            cache.setObject(imageResponse.0 as NSData, forKey: url as NSURL)
            return UIImage(data: imageResponse.0)
        }
    }
}
