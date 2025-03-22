// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public enum LogLevel: String {
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

public class Logger {
    nonisolated(unsafe) public static let shared = Logger()
    
    private init() {}
    
    public func log(_ message: String, level: LogLevel = .info) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        print("[\(timestamp)] [\(level.rawValue)] \(message)")
    }
    
    public func info(_ message: String) {
        log(message, level: .info)
    }
    
    public func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    public func error(_ message: String) {
        log(message, level: .error)
    }
}
