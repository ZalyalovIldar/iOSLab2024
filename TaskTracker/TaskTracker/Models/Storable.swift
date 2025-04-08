//
//  Storage.swift
//  TaskTracker
//
//  Created by Тагир Файрушин on 07.04.2025.
//

import Foundation

protocol Storable: Hashable, Codable, Identifiable {
    var id: UUID { get }
}
