//
//  StorageError.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import Foundation

enum StorageError: Error {
    case decodingFailed
    case encodingFailed
    
    var localizedDescription: String {
        switch self {
        case .decodingFailed: return "Failed to decode data"
        case .encodingFailed: return "Failed to encode data"
        }
    }
}
