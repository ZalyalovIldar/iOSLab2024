//
//  UserDefaultsErrors.swift
//  HW2.2
//
//  Created by Данил Забинский on 07.04.2025.
//

import Foundation

enum UserDefaultsErrors: Error {
    case failureDuringDecodingError(Error),
         failureDiringEncodingError(Error),
         failureDiringSavingData(Error)
    
    var description: String {
        switch self {
        case .failureDuringDecodingError(let error):
            return "Failure during deconding items: \(error.localizedDescription)"
        case .failureDiringEncodingError(let error):
            return "Failure during enconding items: \(error.localizedDescription)"
        case .failureDiringSavingData(let error):
            return "Failure during saving items: \(error.localizedDescription)"
        }
    }
}
