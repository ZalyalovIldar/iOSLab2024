//
//  Storable.swift
//  GenericMVVM
//
//  Created by Anna on 13.04.2025.
//

import Foundation

protocol Storable: Codable {
    var id: String { get }
}
