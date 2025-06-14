//
//  DetailedReminderUITests.swift
//  HW_2.3
//
//  Created by Павел Калинин on 13.06.2025.
//
import XCTest
@testable import HW_2_3

final class DetailedReminderUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    func testReminderDeeplinkOpensDetailScreen() {
        let reminderId = UUID().uuidString
        let deeplinkURL = "healthreminder://openScreen?screen=detail&id=\(reminderId)"
        
        let app = XCUIApplication()
        app.launchArguments = ["--uitesting", "--uitesting-deeplink"]
        app.launchEnvironment["TEST_SCREEN_LINK"] = deeplinkURL
        app.launchEnvironment["TEST_REMINDER_ID"] = reminderId
        
        app.launch()
        
        XCTAssertTrue(app.staticTexts["UI-тест напоминание"].waitForExistence(timeout: 2))
    }
}
