//
//  DetailedReminderView.swift
//  HW_2.3
//
//  Created by Павел Калинин on 11.06.2025.
//

import SwiftUI

struct DetailedReminderView: View {
    var reminder: Reminder

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(reminder.title)
                        .bold()
                        .font(.title)
                    Text(reminder.type.rawValue)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(reminder.date.formatted(date: .omitted, time: .shortened))")
                        .bold()
                    Text("\(reminder.date.formatted(date: .numeric, time: .omitted))")
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailedReminderView(reminder: Reminder(id: UUID(), title: "Иди пей", date: Date(), type: .water))
}
