//
//  StorageService.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import Foundation

final class StorageService<Item: Storable>: StorageServiceProtocol {
 
    typealias Element = Item
    
    private let userDefaults: UserDefaults
    private let key: String
    
    init(userDefaults: UserDefaults = .standard, key: String = String(describing: Item.self)) {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    func getAll() throws -> [Element] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        
        do {
            return try JSONDecoder().decode([Item].self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }

    func saveItems(_ elements: [Element]) throws {
        do {
            let data = try JSONEncoder().encode(elements)
            userDefaults.set(data, forKey: key)
        } catch {
            throw StorageError.encodingFailed
        }
    }
}
