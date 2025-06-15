//
//  FinalHomeWorkProjectTests.swift
//  FinalHomeWorkProjectTests
//
//  Created by Терёхин Иван on 15.06.2025.
//

import XCTest
@testable import FinalHomeWorkProject

final class ReminderServiceTests: XCTestCase {
    
    var sut: ReminderService!
    var mockPushNotificationService: MockPushNotificationService!
    
    override func setUp() {
        super.setUp()
        mockPushNotificationService = MockPushNotificationService()
        sut = ReminderService()
    }
    
    override func tearDown() {
        sut = nil
        mockPushNotificationService = nil
        super.tearDown()
    }
    
    
    func testRemindersPublisher() {
        // Given
        let reminder = Reminder(id: "1", title: "Test", reminderType: .drinkWater, interval: 1)
        let expectation = self.expectation(description: "Reminders publisher")
        var receivedReminders: [Reminder] = []
        
        let cancellable = sut.remindersPublisher
            .sink { reminders in
                receivedReminders = reminders
                if !reminders.isEmpty {
                    expectation.fulfill()
                }
            }
        
        // When
        sut.addReminder(reminder)
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(receivedReminders.count, 1)
        XCTAssertEqual(receivedReminders.first?.id, "1")
        cancellable.cancel()
    }
    
    func testGetReminderById() {
        // Given
        let reminder1 = Reminder(id: "1", title: "Test1", reminderType: .breathing, interval: 1)
        let reminder2 = Reminder(id: "2", title: "Test2", reminderType: .meal, interval: 2)
        sut.addReminder(reminder1)
        sut.addReminder(reminder2)
        
        // When
        let foundReminder = sut.reminder(with: "2")
        
        // Then
        XCTAssertNotNil(foundReminder)
        XCTAssertEqual(foundReminder?.title, "Test2")
    }
    
    func testGetReminderByIdNotFound() {
        // Given
        let reminder = Reminder(id: "1", title: "Test", reminderType: .sleep, interval: 1)
        sut.addReminder(reminder)
        
        // When
        let foundReminder = sut.reminder(with: "999")
        
        // Then
        XCTAssertNil(foundReminder)
    }
}

class MockPushNotificationService: PushNotificationServiceProtocol {
    func registerNotification() async throws -> Bool {
        return false
    }
    
    func open(url: URL) {
        
    }
    
    var didScheduleNotification = false
    
    func scheduleNotification(_ request: UNNotificationRequest) {
        didScheduleNotification = true
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {}
    func getPendingNotificationRequests(completion: @escaping ([UNNotificationRequest]) -> Void) {}
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {}
}
