//
//  HW.swift
//  HW_2.3
//
//  Created by Павел Калинин on 12.06.2025.
//
import XCTest

final class AddReminderUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddReminderFlow() throws {
        let addButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(addButton.exists)
        addButton.tap()
        
        let titleField = app.textFields["Название"]
        XCTAssertTrue(titleField.exists)
        titleField.tap()
        titleField.typeText("Пить воду")


        let picker = app.pickers["Тип"]
        if picker.exists {
            picker.adjust(toPickerWheelValue: "Пить воду")
        }

        let saveButton = app.buttons["Сохранить"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()

        let reminderCell = app.tables.staticTexts["Пить воду"]
        let exists = reminderCell.waitForExistence(timeout: 2)
        XCTAssertTrue(exists)
    }
}
