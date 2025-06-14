//
//  NotificationFactoryTests.swift
//  HW_2.3
//
//  Created by Павел Калинин on 12.06.2025.
//


import XCTest
import UserNotifications
@testable import HW_2_3

final class NotificationFactoryTests: XCTestCase {
    var factory: NotificationFactory!

    override func setUp() {
        super.setUp()
        factory = NotificationFactory()
    }

    override func tearDown() {
        factory = nil
        super.tearDown()
    }

    func test_makeNotification_shouldCreateCorrectRequest() {
        // given
        let id = UUID()
        let date = Date(timeIntervalSince1970: 1_714_569_600)
        let reminder = Reminder(id: id, title: "Drink Water", date: date, type: .water)

        // when
        let request = factory.makeNotification(from: reminder)

        // then
        XCTAssertEqual(request.identifier, id.uuidString)
        XCTAssertEqual(request.content.title, "Drink Water")
        XCTAssertEqual(request.content.body, "Пить воду")
        XCTAssertEqual(request.content.sound, UNNotificationSound.default)
        XCTAssertEqual(request.content.userInfo["screenLink"] as? String, "healthreminder://openScreen?screen=detail&id=\(id)")

        let trigger = request.trigger as? UNCalendarNotificationTrigger
        let expectedComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        XCTAssertEqual(trigger?.dateComponents.year, expectedComponents.year)
        XCTAssertEqual(trigger?.dateComponents.month, expectedComponents.month)
        XCTAssertEqual(trigger?.repeats, false)
    }
}
