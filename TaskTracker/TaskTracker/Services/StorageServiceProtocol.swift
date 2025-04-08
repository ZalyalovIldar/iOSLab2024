//
//  StorageServiceProtocol.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import Foundation

protocol StorageServiceProtocol {
    associatedtype Element
 
    func getAll() throws -> [Element]
    func saveItems(_ elements: [Element]) throws
}
