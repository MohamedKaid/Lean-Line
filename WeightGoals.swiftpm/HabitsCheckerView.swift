//
//  HabitsCheckerView.swift
//  WeightGoals
//
//  Created by Mohamed Kaid on 2/24/26.
//

import SwiftUI

struct HabitsCheckerView: View {
    let goal: Goal

    @State private var done1 = false
    @State private var done2 = false
    @State private var done3 = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Daily Habits")
                        .font(.largeTitle)
                        .bold()
                    Text("Check off your 3 habits for today.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                habitRow(text: goal.habit1, isDone: $done1)
                habitRow(text: goal.habit2, isDone: $done2)
                habitRow(text: goal.habit3, isDone: $done3)

                Button("Reset Today") {
                    done1 = false
                    done2 = false
                    done3 = false
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func habitRow(text: String, isDone: Binding<Bool>) -> some View {
        Button {
            isDone.wrappedValue.toggle()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isDone.wrappedValue ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                Text(text)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
