//
//  StorageService.swift
//  TaskManager
//
//  Created by Damir Rakhmatullin on 10.04.25.
//

import Foundation

protocol Storable: Codable {
    associatedtype Identifier: Hashable
    var id: Identifier { get }
}

protocol StorageServiceProtocol {
    associatedtype Item: Storable
    func save(items: [Item])
    func load() -> [Item]
    func update(item: Item)
}

class StorageService<T: Storable>: StorageServiceProtocol {
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func save(items: [T]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func load() -> [T] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func update(item: T) {
        var items = load()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save(items: items)
        }
    }
    
}
