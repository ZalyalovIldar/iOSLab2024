//
//  Storable.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import Foundation

protocol Storable: Codable, Hashable, Identifiable {
    var id: UUID { get set }
}
