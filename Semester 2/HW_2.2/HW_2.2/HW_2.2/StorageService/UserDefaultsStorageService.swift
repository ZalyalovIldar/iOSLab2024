//
//  UserDefaultsStorageService.swift
//  HW_2.2
//
//  Created by Павел Калинин on 06.04.2025.
//
import Foundation

class UserDefaultsStorageService: StorageService {
    
    private let userDefaults = UserDefaults.standard
    
    //Сохраняет переданные данные по ключу
    func save<T: Storable>(_ items: [T], forKey key: String) {
        if let json = try? JSONEncoder().encode(items) {
            userDefaults.set(json, forKey: key)
        }
    }
    
    //Загружает данные из хранилища по ключу
    func load<T: Storable>(forKey key: String) -> [T] {
        guard let data = userDefaults.data(forKey: key), let items = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return items
    }
    
    //Обновляет определенный элемент
    func update<T: Storable>(_ item: T, forKey key: String) {
        var items: [T] = load(forKey: key)
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save(items, forKey: key)
        }
    }
    
    //Удаляет определенный элемент из хранилища
    func delete<T: Storable>(_ item: T, forKey key: String) {
        var items: [T] = load(forKey: key)
        items.removeAll { $0.id == item.id }
        save(items, forKey: key)
    }
}
