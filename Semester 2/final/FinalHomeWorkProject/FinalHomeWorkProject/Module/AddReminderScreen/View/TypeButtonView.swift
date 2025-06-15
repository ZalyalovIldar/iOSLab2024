//
//  TypeButtonView.swift
//  FinalHomeWork
//
//  Created by Терёхин Иван on 14.06.2025.
//

import SwiftUI

struct TypeButtonView: View {
    let type: ReminderType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: type.iconName)
                    .font(.title)
                    .padding(10)
                    .background(.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? .blue : Color.clear, lineWidth: 2)
                    )
                
                Text(type.rawValue)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
            }
            .frame(width: 90, height: 90)
        }
        .buttonStyle(.plain)
    }
}
