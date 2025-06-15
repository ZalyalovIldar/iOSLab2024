//
//  AddReminderView.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//

import SwiftUI

struct AddReminderView: View {
    @ObservedObject var viewModel: AddReminderViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            mainForm
                .navigationTitle("Новое напоминание")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        saveButton
                    }
                }
        }
    }
    
    private var saveButton: some View {
        Button("Сохранить") {
            viewModel.saveReminder()
            dismiss()
        }
        .disabled(viewModel.title.isEmpty)
    }
    
    private var mainForm: some View {
        Form {
            textInputSection
            typeSelectionSection
            intervalSelectionSection
        }
    }
    
    private var textInputSection: some View {
        Section {
            TextField("Текст напоминания", text: $viewModel.title)
                .font(.headline)
        } header: {
            Text("О чем напомнить?")
        }
    }
    
    private var typeSelectionSection: some View {
        Section {
            typeScrollView
        } header: {
            Text("Тип напоминания")
        }
    }
    
    private var typeScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.reminderTypes) { type in
                    TypeButtonView(
                        type: type,
                        isSelected: viewModel.selectedType == type
                    ) {
                        viewModel.selectedType = type
                        if viewModel.title.isEmpty {
                            viewModel.title = type.rawValue
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var intervalSelectionSection: some View {
        Section {
            intervalStepper
            intervalPicker
        } header: {
            Text("Интервал повторения")
        }
    }
    
    private var intervalStepper: some View {
        Stepper(value: $viewModel.intervalInHours, in: 1...24, step: 1) {
            HStack {
                Image(systemName: "clock")
                Text("Повторять каждые")
                Spacer()
                Text("\(viewModel.intervalInHours) ч")
                    .foregroundColor(.accentColor)
                    .bold()
            }
        }
    }
    
    private var intervalPicker: some View {
        Picker("Повторение", selection: $viewModel.intervalInHours) {
            ForEach(1..<25) { hour in
                Text("\(hour) \(hour == 1 ? "час" : "часа")").tag(hour)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 150)
    }
}


