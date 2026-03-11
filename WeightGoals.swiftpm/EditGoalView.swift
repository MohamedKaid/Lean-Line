import SwiftUI

struct EditGoalView: View {
    @Binding var goals: [Goal]
    let existing: Goal

    @Environment(\.dismiss) private var dismiss

    @State private var CWeight: String
    @State private var LGoal: String
    @State private var mini1: String
    @State private var mini2: String
    @State private var mini3: String

    @State private var pick1: String
    @State private var pick2: String
    @State private var pick3: String

    @State private var length: Int

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    // ✅ Focus control for number pad fields
    private enum Field: Hashable {
        case cWeight, lGoal, mini1, mini2, mini3
    }
    @FocusState private var focusedField: Field?

    private let habits: [String] = [
        "Drink a glass of water before meals",
        "Eat slowly and put the fork down between bites",
        "Include protein with every meal",
        "Fill half your plate with vegetables",
        "Stop eating when no longer hungry, not when full",
        "Cut liquid calories like soda and sweet drinks",
        "Choose healthier snacks like fruit, nuts, or yogurt",
        "Walk 20–30 minutes per day",
        "Stand more and sit less throughout the day",
        "Take the stairs when possible",
        "Move lightly for 10–15 minutes after meals",
        "Stretch or move while watching TV",
        "Sleep 7–8 hours each night",
        "Eat meals at consistent times each day",
        "Avoid late-night snacking",
        "Brush teeth after dinner to signal the kitchen is closed",
        "Keep junk food out of sight",
        "Focus on consistency over perfection",
        "Do not let one bad meal ruin the day",
        "Track progress weekly instead of daily",
        "Focus on habits rather than the scale",
        "Celebrate small wins like more energy or better fitting clothes",
        "Swap fried foods for grilled or baked options",
        "Choose whole grains instead of refined grains",
        "Replace soda with water or zero-calorie drinks",
        "Serve slightly smaller portions",
        "Choose home-cooked meals over fast food when possible"
    ]

    init(goals: Binding<[Goal]>, existing: Goal) {
        self._goals = goals
        self.existing = existing

        _CWeight = State(initialValue: existing.currentWeight)
        _LGoal = State(initialValue: existing.goalWeight)
        _mini1 = State(initialValue: existing.miniGoal1)
        _mini2 = State(initialValue: existing.miniGoal2)
        _mini3 = State(initialValue: existing.miniGoal3)

        _pick1 = State(initialValue: existing.habit1)
        _pick2 = State(initialValue: existing.habit2)
        _pick3 = State(initialValue: existing.habit3)

        _length = State(initialValue: existing.weeks)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("Edit Your Plan")
                        .font(.largeTitle)
                        .bold()
                    Text("Update your goal, timeline, mini goals, and habits.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Weight").font(.headline)
                    TextField("Weight", text: $CWeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .cWeight)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .lGoal }
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Goal Weight").font(.headline)
                    TextField("Goal Weight", text: $LGoal)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .lGoal)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .mini1 }
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Timeline").font(.headline)
                    HStack {
                        Stepper("Weeks", value: $length, in: 1...52)
                        Spacer()
                        Text("\(length)")
                            .font(.title3)
                            .bold()
                            .monospacedDigit()
                    }
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Mini Goals").font(.headline)
                    TextField("Mini Weight Goal #1", text: $mini1)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .mini1)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .mini2 }

                    TextField("Mini Weight Goal #2", text: $mini2)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .mini2)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .mini3 }

                    TextField("Mini Weight Goal #3", text: $mini3)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .mini3)
                        .submitLabel(.done)
                        .onSubmit { focusedField = nil }
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Pick 3 Daily Habits").font(.headline)

                    Picker("Habit 1", selection: $pick1) {
                        Text("Select a habit").tag("")
                        ForEach(habits, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)

                    Picker("Habit 2", selection: $pick2) {
                        Text("Select a habit").tag("")
                        ForEach(habits.filter { $0 != pick1 }, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)

                    Picker("Habit 3", selection: $pick3) {
                        Text("Select a habit").tag("")
                        ForEach(habits.filter { $0 != pick1 && $0 != pick2 }, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                }
                .cardStyle()

                Button {
                    saveEdits()
                } label: {
                    Text("Save Changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Spacer(minLength: 20)
            }
            .padding()
        }
        // ✅ "Done" button above the decimal keyboard
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .alert("Can’t Save Yet", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    private func saveEdits() {
        // dismiss keyboard first
        focusedField = nil

        if CWeight.isEmpty || LGoal.isEmpty || mini1.isEmpty || mini2.isEmpty || mini3.isEmpty {
            alertMessage = "Please fill in your current & goal weight, also all 3 mini goals."
            showAlert = true
            return
        }

        if pick1.isEmpty || pick2.isEmpty || pick3.isEmpty {
            alertMessage = "Please select 3 habits."
            showAlert = true
            return
        }

        if pick1 == pick2 || pick1 == pick3 || pick2 == pick3 {
            alertMessage = "Habits cannot be repeated."
            showAlert = true
            return
        }

        let updated = Goal(
            currentWeight: CWeight,
            goalWeight: LGoal,
            weeks: length,
            miniGoal1: mini1,
            miniGoal2: mini2,
            miniGoal3: mini3,
            habit1: pick1,
            habit2: pick2,
            habit3: pick3
        )

        goals.removeAll()
        goals.append(updated)

        // ✅ Go back to WeightGraph (previous screen)
        dismiss()
    }
}

private extension View {
    func cardStyle() -> some View {
        self
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
