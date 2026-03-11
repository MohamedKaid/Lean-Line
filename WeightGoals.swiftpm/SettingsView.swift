import SwiftUI

struct SettingsView: View {
    @Binding var goals: [Goal]
    let currentGoal: Goal

    @Environment(\.dismiss) private var dismiss
    @State private var showResetAlert = false

    var body: some View {
        VStack(spacing: 16) {

            VStack(alignment: .leading, spacing: 6) {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                Text("Manage your plan.")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                showResetAlert = true
            } label: {
                settingsRow(
                    title: "Reset Plan",
                    subtitle: "Clear your current plan and start a new one",
                    icon: "arrow.counterclockwise.circle.fill"
                )
            }
            .buttonStyle(.plain)

            if !goals.isEmpty {
                NavigationLink {
                    EditGoalView(goals: $goals, existing: currentGoal)
                } label: {
                    settingsRow(
                        title: "Edit Current Plan",
                        subtitle: "Update goal, mini goals, and habits",
                        icon: "pencil.circle.fill"
                    )
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset Plan?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }

            Button("Reset", role: .destructive) {
                goals.removeAll()
                UserDefaults.standard.removeObject(forKey: "savedGoal_v1")
                UserDefaults.standard.removeObject(forKey: "WG_challengeStartDate_v1")
                UserDefaults.standard.removeObject(forKey: "WG_points_v1")
                dismiss()
            }
        } message: {
            Text("This will delete your current plan and weight history for this challenge. You’ll start a new plan.")
        }
    }

    private func settingsRow(title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
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
}
