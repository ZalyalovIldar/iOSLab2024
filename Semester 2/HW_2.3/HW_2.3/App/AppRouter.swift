//
//  AppRouter.swift
//  HW_2.3
//
//  Created by Павел Калинин on 12.06.2025.
//
import UIKit
import SwiftUI


final class AppRouter {
    weak var navigationController: UINavigationController?

    func openReminderDetailScreen(for reminder: Reminder) {
        let detailView = DetailedReminderView(reminder: reminder)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
