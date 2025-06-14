//
//  ReminderServiceTests.swift
//  HW_2.3
//
//  Created by Павел Калинин on 12.06.2025.
//


import XCTest
import Combine
@testable import HW_2_3

final class ReminderServiceTests: XCTestCase {
    var service: ReminderService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        service = ReminderService()
        cancellables = []
    }

    override func tearDown() {
        service = nil
        cancellables = nil
        super.tearDown()
    }

    func test_addReminder_shouldStoreReminder() {
        // given
        let reminder = Reminder(id: UUID(), title: "Test", date: Date(), type: .breathing)

        // when
        service.add(reminder)

        // then
        XCTAssertEqual(service.reminder(with: reminder.id)?.title, "Test")
    }

    func test_remindersPublisher_shouldPublishChanges() {
        // given
        let expectation = XCTestExpectation(description: "Should receive reminder")
        let reminder = Reminder(id: UUID(), title: "Published", date: Date(), type: .water)

        var receivedReminders: [Reminder] = []

        service.remindersPublisher
            .sink { reminders in
                receivedReminders = reminders
                if reminders.contains(where: { $0.id == reminder.id }) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // when
        service.add(reminder)

        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(receivedReminders.contains(where: { $0.id == reminder.id }))
    }
}
