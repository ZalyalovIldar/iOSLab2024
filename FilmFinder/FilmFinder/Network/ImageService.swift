//
//  ImageService.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 01.01.2025.
//

import Foundation
import UIKit

class ImageService {
    
    static let cache: NSCache<NSURL, NSData> = .init()
    
    static func downloadImage(from urlString: String) async throws -> UIImage? {
        
        guard let url = URL(string: urlString) else { return nil }
        
        if let imageData = cache.object(forKey: url as NSURL) {
            return UIImage(data: imageData as Data)
        }
        
        let imageDataResponce = try await URLSession.shared.data(from: url)
        
        cache.setObject(imageDataResponce.0 as NSData, forKey: url as NSURL)
        
        return UIImage(data: imageDataResponce.0)
    }
    
    static func downloadImageData(from urlString: String) async throws -> Data? {
        guard let url = URL(string: urlString) else { return nil}
        
        if let imageData = cache.object(forKey: url as NSURL) {
            return imageData as Data
        }
        
        let imageDataResponce = try await URLSession.shared.data(from: url)
        
        cache.setObject(imageDataResponce.0 as NSData, forKey: url as NSURL)
        
        return imageDataResponce.0
    }
}
