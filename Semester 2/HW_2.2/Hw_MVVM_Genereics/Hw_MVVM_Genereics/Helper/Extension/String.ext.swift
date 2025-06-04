//
//  String.ext.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 08.04.2025.
//

import Foundation

//MARK: Key UserDefaults
extension String {
    static let tasks = "tasks"
}

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
