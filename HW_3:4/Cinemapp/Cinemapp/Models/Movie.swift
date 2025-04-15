import Foundation

struct MovieResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let movieDescription: String?
    let poster: Poster?
}

struct Poster: Codable, Hashable {
    let image: String
}


struct City: Codable {
    let name: String
    let slug: String
}

@objc(PosterObject)
public class PosterObject: NSObject, NSSecureCoding {
    let poster: Poster?
    
    init(poster: Poster?) {
        self.poster = poster
    }
    
    public static var supportsSecureCoding: Bool = true
    
    public func encode(with coder: NSCoder) {
        let posterData = try? JSONEncoder().encode(poster)
        coder.encode(posterData, forKey: "poster")
    }
    
    public required init?(coder: NSCoder) {
        if let posterData = coder.decodeObject(of: NSData.self, forKey: "poster") as Data? {
            poster = try? JSONDecoder().decode(Poster.self, from: posterData)
        } else {
            poster = nil
        }
    }
}
