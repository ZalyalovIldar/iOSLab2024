//
//  UserDefaultsStorageService.swift
//  HW2.2
//
//  Created by Павел on 11.04.2025.
//

import Foundation

final class UserDefaultsStorageService: StorageServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    private lazy var jsonEncoder: JSONEncoder = {
        return JSONEncoder()
    }()
    
    private lazy var jsonDecoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    func save<T>(_ items: [T], storageKey: String) where T : Savable {
        if let data = try? jsonEncoder.encode(items) {
            userDefaults.set(data, forKey: storageKey)
        }
    }
    
    func load<T>(storageKey: String) -> [T] where T : Savable {
        guard let data = userDefaults.data(forKey: storageKey), let items = try?
                jsonDecoder.decode([T].self, from: data) else { return [] }
        return items
    }
    
    func update<T>(_ item: T, storageKey: String) where T : Savable {
        var items: [T] = load(storageKey: storageKey)
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save(items, storageKey: storageKey)
        }
    }
    
    func delete<T>(_ item: T, storageKey: String) where T : Savable {
        var items: [T] = load(storageKey: storageKey)
        items.removeAll(where: { $0.id == item.id })
        save(items, storageKey: storageKey)
    }
    
}
