//
//  StorageService.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import Foundation

final class StorageService<T: Storable>: Storage {
    private let storageIdentifier: String
    private let userDefaults = UserDefaults.standard
    
    private lazy var jsonEncoder: JSONEncoder = { JSONEncoder() }()
    private lazy var jsonDecoder: JSONDecoder = { JSONDecoder() }()
    
    init() {
        self.storageIdentifier = "\(T.self)"
    }
    
    func save(_ item: T) {
        saveItem(item)
    }
    
    func getAll() -> [T] {
        getAllItems()
    }
    
    func delete(_ item: T) {
        deleteItem(item)
    }
}

private extension StorageService {
    
    func saveItem(_ item: T) {
        var items = self.getAllItems()
        items.append(item)
        saveUpdatedData(items)
    }
    
    func getAllItems() -> [T] {
        guard let usersData = userDefaults.data(forKey: storageIdentifier) else { return [] }
        do {
            let todos = try jsonDecoder.decode([T].self, from: usersData)
            return todos
        } catch {
            print(UserDefaultsErrors.failureDuringDecodingError(error).description)
            fatalError("Error during decoding items: \(error.localizedDescription)")
        }
    }
    
    func deleteItem(_ item: T) {
        var items = self.getAllItems()
        items.removeAll { $0.id == item.id }
        saveUpdatedData(items)
    }
    
    func saveUpdatedData(_ items: [T]) {
        do {
            let data = try jsonEncoder.encode(items)
            userDefaults.set(data, forKey: storageIdentifier)
        } catch {
            print(UserDefaultsErrors.failureDiringSavingData(error).description)
        }
    }
}
