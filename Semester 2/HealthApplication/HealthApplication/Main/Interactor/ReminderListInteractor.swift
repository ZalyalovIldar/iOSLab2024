class ReminderListInteractor{
    weak var presenter: ReminderListPresenterProtocol?
    
    func loadReminders(){
        let reminders = ReminderService.shared.reminders
        presenter?.didLoad(reminders: reminders)
    }
}
