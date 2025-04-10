// The Swift Programming Language
// https://docs.swift.org/swift-book

import OSLog

public class MyCustomLogger {
    
    public enum LogLevel: String {
        case warning = "WARNING"
        case error = "ERROR"
        case critical = "CRITICAL"
    }
    
        
    private static func log(_ message: String,
                            level: LogLevel = .error,
                            file: String = #file,
                            function: String = #function,
                            line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(level.rawValue)] \(fileName):\(line) \(function) - \(message)"
        print(logMessage)
    }
        
    public static func logError(_ error: Error,
                                file: String = #file,
                                function: String = #function,
                                line: Int = #line) {
        log(error.localizedDescription, level: .error, file: file, function: function, line: line)
    }
    
}

