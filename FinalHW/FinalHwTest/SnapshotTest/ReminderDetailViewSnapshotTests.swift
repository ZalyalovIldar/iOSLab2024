import XCTest
import SwiftUI
import SnapshotTesting
@testable import FinalHw

class ReminderDetailViewSnapshotTests: XCTestCase {
    func testReminderDetailView() {
        let reminder = Reminder(title: "Пить воду", interval: 60, type: .water)
        let view = ReminderDetailView(reminder: reminder)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image)
    }
}
