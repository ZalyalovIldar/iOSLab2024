//
//  StorageService.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 07.04.2025.
//

import Foundation

protocol Savable: Hashable {
    var id: UUID { get }
}

protocol StorageServiceProtocol<Item, StorageError> {
    associatedtype Item: Savable
    associatedtype StorageError: Error
    
    func save(items: [Item]) -> Result<Void, StorageError>
    func fetch() -> Result<[Item], StorageError>
    func deleteBy(id: UUID) -> Result<Void, StorageError>
    
}

class UserDefaultsStorageService<Items: Savable & Codable>: StorageServiceProtocol  {
    typealias Item = Items
    typealias StorageError = UserDefaultsError
    
    private let userDefaults: UserDefaults
    private let key: String
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    
    init(userDefaults: UserDefaults = .standard, key: String = .tasks) {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    func save(items: [Items]) -> Result<Void, StorageError> {
        do {
            let data = try encoder.encode(items)
            userDefaults.set(data, forKey: key)
            return .success(())
        } catch {
            return .failure(.decodingError)
        }
    }
    
    func deleteBy(id: UUID) -> Result<Void, UserDefaultsError> {
        var items = obtainAllItems()
        items.removeAll(where: { $0.id == id })
        return save(items: items)
    }
   
    func fetch() -> Result<[Items], StorageError> {
        return .success(obtainAllItems())
    }
    
    private func obtainAllItems() -> [Items] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        return (try? decoder.decode([Items].self, from: data)) ?? []
    }
}

