import Foundation
import UIKit

final class ImageService {
    
    private static let imageCache = NSCache<NSURL, NSData>()
    
    static func downloadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        if let cachedData = imageCache.object(forKey: url as NSURL) {
            return UIImage(data: cachedData as Data)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        imageCache.setObject(data as NSData, forKey: url as NSURL)
        
        return UIImage(data: data)
    }
}
