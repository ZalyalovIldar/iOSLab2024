//
//  MainRouter.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 10.06.2025.
//

import UIKit
import SwiftUI


protocol MainRouterInput {
    func showAddReminderController()
}

final class MainRouter: MainRouterInput {
    weak var view: UIViewController!

    func showAddReminderController()  {
        let controller = UIHostingController(rootView: AddReminderView(viewModel: AddReminderViewModel()))
        view.navigationController?.pushViewController(controller, animated: true)
    }
}
