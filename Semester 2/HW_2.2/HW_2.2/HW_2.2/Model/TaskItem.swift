//
//  Storable.swift
//  HW_2.2
//
//  Created by Павел Калинин on 06.04.2025.
//
import Foundation

protocol Storable: Codable, Identifiable, Hashable {}

struct TaskItem: Storable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}
