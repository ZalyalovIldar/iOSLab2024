import XCTest
@testable import LoggerPackage

final class LoggerPackageTests: XCTestCase {
    func testLogMessage() {
        Logger.log("Это тестовое сообщение", level: .info)
    }

    func testLogError() {
        let error = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Тестовая ошибка"])
        Logger.logError(error)
    }
}
