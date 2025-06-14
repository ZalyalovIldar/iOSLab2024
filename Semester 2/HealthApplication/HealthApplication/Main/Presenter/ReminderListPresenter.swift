import UIKit

protocol ReminderListPresenterProtocol: AnyObject{
    func loadReminders()
    func didLoad(reminders: [Reminder])
    func showCreateScreen(from viewController: UIViewController)
    func showDetail(reminder: Reminder)
}

class ReminderListPresenter: ReminderListPresenterProtocol{
    weak var view: ReminderListViewProtocol?
    private let interactor = ReminderListInteractor()
    private let router = ReminderListRouter()
    
    init(view: ReminderListViewProtocol) {
        self.view = view
        self.interactor.presenter = self
    }
    
    func loadReminders() {
        interactor.loadReminders()
    }
    
    func didLoad(reminders: [Reminder]) {
        view?.update(with: reminders)
    }
    
    func showCreateScreen(from viewController: UIViewController) {
        router.showCreateScreen(from: viewController)
    }
    
    func showDetail(reminder: Reminder) {
        router.showDetail(reminder: reminder)
    }
}
