//
//  StorageService.swift
//  HW2.2
//
//  Created by Павел on 11.04.2025.
//

protocol StorageServiceProtocol {
    func save<T: Savable>(_ items: [T], storageKey: String)
    func load<T: Savable>(storageKey: String) -> [T]
    func update<T: Savable>(_ item: T, storageKey: String)
    func delete<T: Savable>(_ item: T, storageKey: String)
}
