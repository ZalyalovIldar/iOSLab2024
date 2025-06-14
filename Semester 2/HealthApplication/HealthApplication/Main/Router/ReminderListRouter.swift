import SwiftUI
import UIKit

class ReminderListRouter{
    func showCreateScreen(from viewController: UIViewController){
        let createView = CreateReminderView()
        let hostingVC = UIHostingController(rootView: createView)
        viewController.navigationController?.pushViewController(hostingVC, animated: true)
    }
    
    func showDetail(reminder: Reminder){
        let detailView = ReminderDetailView(reminder: reminder)
        let hostingVC = UIHostingController(rootView: detailView)
        UIApplication.getTopViewController()?.present(hostingVC, animated: true)
    }
}
