//
//  StorageService.swift
//  GenericMVVM
//
//  Created by Anna on 13.04.2025.
//

import Foundation

protocol StorageServiceProtocol<Item> {
    associatedtype Item: Storable // Item - любой Storable
    func save(_ item: Item)
    func fetchAll() -> [Item]
    func update(_ item: Item)
    func delete(_ item: Item)
}

class StorageService<Item: Storable>: StorageServiceProtocol {
    private let storageKey: String
    
    init(storageKey: String) {
        self.storageKey = storageKey
    }
    
    func save(_ item: Item) {
        var items = fetchAll()
        items.append(item)
        saveItems(items)
    }
    
    func fetchAll() -> [Item] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([Item].self, from: data)) ?? []
    }
    
    func update(_ item: Item) {
        var items = fetchAll()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems(items)
        }
    }
    
    func delete(_ item: Item) {
        var items = fetchAll()
        items.removeAll { $0.id == item.id }
        saveItems(items)
    }
    
    private func saveItems(_ items: [Item]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
