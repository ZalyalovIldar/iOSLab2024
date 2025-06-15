//
//  ImageService.swift
//  Movies
//
//  Created by Павел Калинин on 22.12.2024.
//
import UIKit

class ImageService {
    static let shared = ImageService()
    private init() {}
    
    let cache = NSCache<NSURL, NSData>()
    
    let session: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    func downloadImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { return UIImage()}
        
        if let imageData = cache.object(forKey: url as NSURL) {
            return UIImage(data: imageData as Data) ?? .default
        }
        
        let responseData = try await URLSession.shared.data(from: url)
        cache.setObject(responseData.0 as NSData, forKey: url as NSURL)
        return UIImage(data: responseData.0 as Data) ?? .default
    }
}
