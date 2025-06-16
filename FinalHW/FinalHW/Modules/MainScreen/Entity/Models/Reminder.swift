import Foundation

// Модель напоминания
struct Reminder: Identifiable {
    let id = UUID()
    let title: String
    let interval: Int // в минутах
    let type: ReminderType
}

// Типы напоминаний
enum ReminderType: String, CaseIterable {
    case water = "Пить воду"
    case exercise = "Разминка"
    case vitamins = "Витамины"
    case sleep = "Лечь спать"
    case charge = "Зарядка"
    case food = "Приём пищи"
    case breathing = "Дыхательные упражнения"
    case custom = "Свой тип"
}
