//
//  FormattedDate.swift
//  Hw_MVVM_Genereics
//
//  Created by Терёхин Иван on 07.04.2025.
//

import Foundation

class FormattedDate {
    static func formated(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
}
