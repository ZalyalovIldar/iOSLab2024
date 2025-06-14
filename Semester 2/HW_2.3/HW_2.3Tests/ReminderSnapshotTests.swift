//
//  ReminderSnapshotTests.swift
//  HW_2.3
//
//  Created by Павел Калинин on 12.06.2025.
//



import XCTest
import SwiftUI
import SnapshotTesting

@testable import HW_2_3

final class ReminderSnapshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
        isRecording = false
    }

    func test_AddReminderView_EmptyState() {
        let view = AddReminderView()
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhone13))
    }

    func test_DetailedReminderView() {
        let reminder = Reminder(
            id: UUID(),
            title: "Выпей воды",
            date: Date(timeIntervalSince1970: 1_714_569_600),
            type: .water
        )
        let view = DetailedReminderView(reminder: reminder)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhone13))
    }
}
