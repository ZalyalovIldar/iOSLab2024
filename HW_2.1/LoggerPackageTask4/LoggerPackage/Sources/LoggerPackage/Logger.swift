//
//  File.swift
//  
//
//  Created by Anna on 22.03.2025.
//

import Foundation

import Foundation

public class Logger {
    // Уровни логирования
    public enum LogLevel: String {
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "❌ ERROR"
        case debug = "🔍 DEBUG"
    }

    // Логирование сообщения с указанным уровнем
    public static func log(_ message: String, level: LogLevel = .info, file: String = #file, line: Int = #line, function: String = #function) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(level.rawValue) [\(fileName):\(line) \(function)]: \(message)"
        print(logMessage)
    }

    // Логирование ошибки
    public static func logError(_ error: Error, file: String = #file, line: Int = #line, function: String = #function) {
        log("\(error.localizedDescription)", level: .error, file: file, line: line, function: function)
    }
}
