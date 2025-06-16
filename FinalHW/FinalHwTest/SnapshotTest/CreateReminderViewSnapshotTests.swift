import XCTest
import SwiftUI
import SnapshotTesting
@testable import FinalHw

class CreateReminderViewSnapshotTests: XCTestCase {
    func testCreateReminderView_WithEmptyFields() {
        let view = CreateReminderView()
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image)
    }
}
