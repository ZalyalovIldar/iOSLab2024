// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public enum LogLevel: String {
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

public struct ErrorLogger {
    
    public static func log(_ message: String, level: LogLevel = .info) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        print("[\(timestamp)] [\(level.rawValue)] \(message)")
    }
    
    public static func logError(_ error: Error) {
        log(error.localizedDescription, level: .error)
    }
}
