//
//  StorageService.swift
//  hw2.2
//
//  Created by Кирилл Титов on 11.04.2025.
//

import Foundation

protocol Storable {
    associatedtype Item: Codable, Identifiable
}

protocol StorageServiceProtocol {
    associatedtype Item: Codable, Identifiable
    
    func save(_ items: [Item]) throws
    func load() throws -> [Item]
    func update(_ item: Item) throws
    func delete(_ item: Item) throws
}

class UserDefaultsStorageService<T: Codable & Identifiable>: StorageServiceProtocol {
    private let key: String
    
    init(key: String = "StorageKey") {
        self.key = key
    }
    
    func save(_ items: [T]) throws {
        let data = try JSONEncoder().encode(items)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load() throws -> [T] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        return try JSONDecoder().decode([T].self, from: data)
    }
    
    func update(_ item: T) throws {
        var items = try load()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
        try save(items)
    }
    
    func delete(_ item: T) throws {
        var items = try load()
        items.removeAll { $0.id == item.id }
        try save(items)
    }
}
