import OSLog

public struct LogErrors {
    private static let osLogger = Logger(subsystem: "com.PavelSushkov.MyOwnGOATPackageHW", category: "errors")
    
    public static func logInfo(_ message: String) {
        print("ℹ️ info: \(message)")
        osLogger.info("\(message, privacy: .public)")
    }
    
    public static func logWarning(_ message: String) {
        print("⚠️ warning: \(message)")
        osLogger.warning("\(message, privacy: .public)")
    }
    
    public static func logError(_ error: Error) {
        print("❌ error: \(error.localizedDescription)")
        osLogger.error("\(error, privacy: .public)")
    }
}
