import Combine
import Foundation

class ReminderService{
    static let shared = ReminderService()
    
    @Published var reminders: [Reminder] = [] {
        didSet{
            saveReminders()
        }
    }
    
    private let remindersKey = "RemindersKey"
    
    private init() {
        loadReminders()
    }
    
    func add(_ reminder: Reminder){
        reminders.append(reminder)
        print("Текущие напоминания: \(reminders)")
    }
    
    func remove(_ reminder: Reminder){
        reminders.removeAll{$0.id == reminder.id}
    }
    
    private func saveReminders(){
        do {
            let data = try JSONEncoder().encode(reminders)
            UserDefaults.standard.set(data, forKey: remindersKey)
            print("Напоминания сохранены")
        } catch {
            print("Не вышло закодировать напоминалки")
        }
    }
    
    private func loadReminders(){
        guard let data = UserDefaults.standard.data(forKey: remindersKey)
        else {
            print("Напоминалки не найдены")
            return
        }
        do {
            let decodedReminders = try JSONDecoder().decode([Reminder].self, from: data)
            reminders = decodedReminders
            print("Напоминания декодированы")
            for reminder in reminders{
                NotificationFactory.schedule(notificationFor: reminder)
            }
        } catch {
            print("Ошибка при декодировании")
        }
    }
}
