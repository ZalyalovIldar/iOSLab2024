import SwiftUI

struct ReminderDetailView: View {
    let reminder: Reminder
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Напоминание").font(.title)
            Divider()
            Text("Название: \(reminder.title)")
            Text("Тип: \(reminder.type.description)")
            Text("Интервал: \(reminder.interval) минут")
            Spacer()
        }
        .padding()
        .navigationTitle("Детали")
    }
}
