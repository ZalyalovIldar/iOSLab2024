import Foundation
public struct ErrorLogger {
    
    public static func logError(_ error: Error) {
        if let localizedError = error as? LocalizedError,
           let description = localizedError.errorDescription {
            print("Ошибка: \(description)")
        } else {
            print("Ошибка: \(error)")
        }
    }

    
    public static func logMessage(_ message: String) {
        print("Сообщение: \(message)")
    }
}
