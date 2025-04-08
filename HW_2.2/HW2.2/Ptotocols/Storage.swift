//
//  Storage.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import Foundation

protocol Storage<T> {
    associatedtype T: Storable
    
    func save(_ item: T)
    func getAll() -> [T]
    func delete(_ item: T)
}
