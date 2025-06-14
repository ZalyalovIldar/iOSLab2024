import SwiftUI

struct CreateReminderView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var interval: Int = 10
    @State private var selectedType: ReminderType = .water
    @State private var customType: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Тип")) {
                    Picker("Выберите тип", selection: $selectedType) {
                        ForEach(ReminderType.allCases, id: \.self) { type in
                            Text(type.description).tag(type)
                        }
                    }
                    if case .custom = selectedType {
                        TextField("Введите свой тип", text: $customType)
                    }
                }
                Section(header: Text("Интервал")) {
                    // MARK: изначально стояло от 5 до 60 минут с шагом 5, поставил поменьше для теста
                    Stepper(value: $interval, in: 1...60, step: 1) {
                        Text("Каждые \(interval) минут")
                    }
                }
                Section(header: Text("Название")) {
                    TextField("Пример: Напоминание", text: $title)
                }
                Button("Сохранить") {
                    print("Кнопка 'Сохранить' нажата!")
                    let finalTitle = title.isEmpty ? "Новое напоминание" : title
                    print("finalTitle: \(finalTitle)")
                    let reminderType = selectedType.isCustom && !customType.isEmpty ? ReminderType.custom(customType) : selectedType
                    let reminder = ReminderBuilder.build(title: finalTitle, interval: interval, type: reminderType)
                    print("reminder: \(reminder)")
                    ReminderService.shared.add(reminder)
                    print("Reminder добавлен в ReminderService")
                    NotificationFactory.schedule(notificationFor: reminder)
                    print("Уведомление запланировано")
                    presentationMode.wrappedValue.dismiss()
                }

            }
            .navigationTitle("Создать напоминание")
        }
    }
}

