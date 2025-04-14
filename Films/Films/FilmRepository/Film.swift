//
//  Films.swift
//  Films
//
//  Created by Артур Мавликаев on 06.01.2025.
//
import Foundation
struct Film: Decodable, Hashable {
    let id: Int
    let name: String
    let image: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case poster
    }

    private struct Poster: Decodable {
        let image: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        do {
                let poster = try container.decode(Poster.self, forKey: .poster)
                image = poster.image
            } catch {
                image = "https://sun9-27.userapi.com/impg/vGLmVc5Th37dgwtapYPI8gFlNK7KAk4RVCnbUQ/B6TRJ-sElUU.jpg?size=382x512&quality=95&sign=3f3405d5d5696dbee94b521557124c3b&type=album"
            }
    }
}


struct FilmsResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Film]
}

