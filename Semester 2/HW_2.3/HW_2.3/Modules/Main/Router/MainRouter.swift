//
//  MainRouter.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import UIKit
import SwiftUI

protocol MainRouterInput: AnyObject {
    func showAddReminderModule()
    func showDetailedReminderModule(reminder: Reminder)
}

final class MainRouter: MainRouterInput {
    weak var viewController: UIViewController?

    func showAddReminderModule() {
        viewController?.show(UIHostingController(rootView: AddReminderView()), sender: self)
    }

    func showDetailedReminderModule(reminder: Reminder) {
        viewController?.show(UIHostingController(rootView: DetailedReminderView(reminder: reminder)), sender: self)
    }
}
