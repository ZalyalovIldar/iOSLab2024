import Foundation
import UIKit

class ImageService {
    
    static let cache: NSCache<NSURL, NSData> = {
        let myCache = NSCache<NSURL, NSData>()
        myCache.countLimit = 20
        
        return myCache
    }()
    
    static func downloadImage(by urlString: String) async throws  -> UIImage? {
        
        guard let url = URL(string: urlString) else { return nil }
        
        if let imageData = cache.object(forKey: url as NSURL) {
            return UIImage(data: imageData as Data)
        }
                
        let imageDataResponce = try await URLSession.shared.data(from: url)
        
        cache.setObject(imageDataResponce.0 as NSData, forKey: url as NSURL)
        
        return UIImage(data: imageDataResponce.0)
        
    }
    
}
