//
//  UserDefaultsStorage.swift
//  MVVMJen
//
//  Created by Артур Мавликаев on 14.04.2025.
//

import Foundation
class UserDefaultsStorage<T: Codable>: StorageProtocol {
    private let key: String

    init(key: String) {
        self.key = key
    }

    func save(data: [T]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }

    func load() -> [T] {
        guard let savedData = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode([T].self, from: savedData) {
            return decodedData
        }
        return []
    }
}
