//
//  Logger.swift
//  LoggerProject
//
//  Created by Тагир Файрушин on 20.03.2025.
//

import Foundation

public enum LogError: Error {
    case networkError
    case dataParsing
    case unknown
    
    var message: String {
        switch self {
        case .networkError:
            return "Network error: Please check your internet connection"
        case .dataParsing:
            return "Parsing error: Invalid response format"
        case .unknown:
            return "Unknown error: Please try again"
        }
    }
}

public class Logger {
    
    public static func log(error: LogError) {
        let timestamp = getCurrentTime()
        print("[\(timestamp)] Error: \(error.message)")
    }
    
    public static func log(message: String) {
        let timestamp = getCurrentTime()
        print("[\(timestamp)] Error: \(message)")
    }
    
    private static func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
