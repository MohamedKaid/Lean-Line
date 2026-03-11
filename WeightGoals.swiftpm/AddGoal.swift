import SwiftUI

struct AddGoal: View {
    @Binding var goals: [Goal]

    @State private var CWeight: String = ""
    @State private var LGoal: String = ""
    @State private var mini1: String = ""
    @State private var mini2: String = ""

    @State private var pick1: String = ""
    @State private var pick2: String = ""
    @State private var pick3: String = ""

    @State private var length: Int = 1

    @FocusState private var isTyping: Bool

    @State private var goToTabs: Bool = false
    @State private var nextGoal: Goal = Goal(
        currentWeight: "0",
        goalWeight: "0",
        weeks: 1,
        miniGoal1: "0",
        miniGoal2: "0",
        miniGoal3: "0",
        habit1: "",
        habit2: "",
        habit3: ""
    )

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

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

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("Create Your Plan")
                        .font(.largeTitle)
                        .bold()
                    Text("Set a goal, timeline, mini goals, and 3 habits.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Weight").font(.headline)
                    TextField("Weight", text: $CWeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTyping)
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Goal Weight").font(.headline)
                    TextField("Goal Weight", text: $LGoal)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTyping)
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

                // Mini Goals (2)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mini Goals").font(.headline)
                    TextField("Mini Weight Goal #1", text: $mini1)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTyping)
                    TextField("Mini Weight Goal #2", text: $mini2)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTyping)
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Pick 3 Daily Habits").font(.headline)

                    Picker("Habit 1", selection: $pick1) {
                        Text("Select a habit").tag("")
                        ForEach(habits, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.navigationLink)

                    if !pick1.isEmpty {
                        Text(pick1)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Picker("Habit 2", selection: $pick2) {
                        Text("Select a habit").tag("")
                        ForEach(habits.filter { $0 != pick1 }, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.navigationLink)

                    if !pick2.isEmpty {
                        Text(pick2)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Picker("Habit 3", selection: $pick3) {
                        Text("Select a habit").tag("")
                        ForEach(habits.filter { $0 != pick1 && $0 != pick2 }, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.navigationLink)

                    if !pick3.isEmpty {
                        Text(pick3)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .cardStyle()

                Button {
                    isTyping = false
                    saveAndNavigate()
                } label: {
                    Text("Save Plan")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.top, 4)

                NavigationLink("",
                               destination: MainTabsView(goals: $goals),
                               isActive: $goToTabs)
                    .hidden()
            }
            .padding()
        }
        .onTapGesture { isTyping = false }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isTyping = false }
            }
        }
        .alert("Can’t Save Yet", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    private func saveAndNavigate() {
        if CWeight.isEmpty || LGoal.isEmpty || mini1.isEmpty || mini2.isEmpty {
            alertMessage = "Please fill in your current & goal weight, and both mini goals."
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

        func toDouble(_ s: String) -> Double {
            let filtered = s.filter { "0123456789.".contains($0) }
            return Double(filtered) ?? 0
        }

        let current = toDouble(CWeight)
        let goal = toDouble(LGoal)
        let m1 = toDouble(mini1)
        let m2 = toDouble(mini2)

        if current <= 0 || goal <= 0 {
            alertMessage = "Please enter valid weights."
            showAlert = true
            return
        }

        if goal >= current {
            alertMessage = "Goal weight must be less than current weight."
            showAlert = true
            return
        }

        // ✅ mini goals must be between current and goal
        if !(m1 < current && m1 > goal) || !(m2 < current && m2 > goal) {
            alertMessage = "Mini goals must be less than your current weight and greater than your goal weight."
            showAlert = true
            return
        }

        let newGoal = Goal(
            currentWeight: CWeight,
            goalWeight: LGoal,
            weeks: length,
            miniGoal1: mini1,
            miniGoal2: mini2,
            miniGoal3: "0",
            habit1: pick1,
            habit2: pick2,
            habit3: pick3
        )

        nextGoal = newGoal

        goals.removeAll()
        goals.append(newGoal)

        CWeight = ""
        LGoal = ""
        mini1 = ""
        mini2 = ""
        pick1 = ""
        pick2 = ""
        pick3 = ""
        length = 1

        goToTabs = true
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
