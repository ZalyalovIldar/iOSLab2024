//
//  DetailScreen.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 15.06.2025.
//

import SwiftUI

struct DetailView: View {
    var reminder: Reminder

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text(reminder.title)
                    .font(.title)
                    .bold()

                Label(reminder.reminderType.rawValue, systemImage: "tag")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Label("Повторяется каждые \(formatInterval(reminder.interval))", systemImage: "clock")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal)

        }
        .navigationTitle("Детали напоминания")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        return "\(hours) ч"
    }
}

#Preview {
    DetailView(reminder: Reminder(id: "dsfsd", title: "Пить воду", reminderType: .drinkWater, interval: 7200))
}


