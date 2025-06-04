//
//  StorageService.swift
//  HW_2.2
//
//  Created by Павел Калинин on 06.04.2025.
//


protocol StorageService {
    func save<T: Storable>(_ items: [T], forKey key: String)
    func load<T: Storable>(forKey key: String) -> [T]
    func update<T: Storable>(_ item: T, forKey key: String)
    func delete<T: Storable>(_ item: T, forKey key: String)
}

