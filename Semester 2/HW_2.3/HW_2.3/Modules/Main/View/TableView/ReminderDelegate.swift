//
//  ReminderDelegate.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//
import UIKit

final class ReminderDelegate: NSObject, UITableViewDelegate {
    weak var viewController: MainViewController?

    init(viewController: MainViewController? = nil) {
        self.viewController = viewController
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reminder = viewController?.dataSource.getReminder(at: indexPath.row) else { return }
        viewController?.presenter?.showDetailedReminderModule(reminder: reminder)
    }
}
