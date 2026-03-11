import SwiftUI
import Charts

struct WeightGraph: View {
    let weightGoal: Goal

    struct WeightPoint: Identifiable, Codable {
        let id: UUID
        let day: Int
        let weight: Double

        init(day: Int, weight: Double) {
            self.id = UUID()
            self.day = day
            self.weight = weight
        }
    }

    @State private var startWeight: Double = 0
    @State private var targetWeight: Double = 0
    @State private var miniGoal1Weight: Double = 0
    @State private var miniGoal2Weight: Double = 0
    @State private var totalWeeks: Int = 0

    @State private var points: [WeightPoint] = []
    @State private var todayWeight: String = ""

    @State private var challengeStartDate: Date = Date()
    @State private var challengeOver: Bool = false

    @State private var yMin: Double = 0
    @State private var yMax: Double = 1
    private let yPadding: Double = 15

    @FocusState private var weightFieldFocused: Bool

    private let keyStartDate = "WG_challengeStartDate_v1"
    private let keyPoints = "WG_points_v1"

    private var durationDays: Int { max(totalWeeks * 7, 1) }

    @State private var visibleStartDay: Int = 0
    private let visibleWindowDays: Int = 7

    private var visibleDayTicks: [Int] {
        let end = min(visibleStartDay + visibleWindowDays, durationDays)
        return Array(visibleStartDay...end)
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight (lb)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Chart {
                        ForEach(points) { p in
                            LineMark(
                                x: .value("Day", p.day),
                                y: .value("Weight", p.weight),
                                series: .value("Week", p.day / 7)
                            )
                        }

                        ForEach(points) { p in
                            PointMark(
                                x: .value("Day", p.day),
                                y: .value("Weight", p.weight)
                            )
                            .annotation(position: .bottom, alignment: .center) {
                                Text("\(p.weight, specifier: "%.0f")")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        if miniGoal1Weight > 0 {
                            RuleMark(y: .value("MiniGoal1", miniGoal1Weight))
                                .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 6]))
                                .foregroundStyle(.secondary.opacity(0.7))
                                .annotation(position: .overlay, alignment: .center) {
                                    Text("— — —  Mini Goal \(miniGoal1Weight, specifier: "%.0f") lb  — — —")
                                        .font(.caption2)
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 8)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
                                }
                        }

                        if miniGoal2Weight > 0 {
                            RuleMark(y: .value("MiniGoal2", miniGoal2Weight))
                                .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 6]))
                                .foregroundStyle(.secondary.opacity(0.7))
                                .annotation(position: .overlay, alignment: .center) {
                                    Text("— — —  Mini Goal \(miniGoal2Weight, specifier: "%.0f") lb  — — —")
                                        .font(.caption2)
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 8)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
                                }
                        }

                        RuleMark(y: .value("Goal", targetWeight))
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 6]))
                            .foregroundStyle(.secondary)
                            .annotation(position: .overlay, alignment: .center) {
                                Text("— — —  Goal \(targetWeight, specifier: "%.0f") lb  — — —")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                    .padding(.horizontal, 8)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                            }
                    }
                    .frame(height: 280)
                    .chartYScale(domain: yMin...yMax)
                    .chartXScale(domain: visibleStartDay...(visibleStartDay + visibleWindowDays))

                    .chartXAxis {
                        AxisMarks(values: visibleDayTicks) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let day = value.as(Int.self) { Text("\(day)") }
                            }
                        }
                    }

                    .chartYAxis {
                        AxisMarks(position: .leading) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }

                    HStack {
                        Button("◀︎ Prev") { moveWeek(-1) }
                            .buttonStyle(.bordered)
                            .disabled(visibleStartDay <= 0)

                        Spacer()

                        Text("Days \(visibleStartDay)–\(min(visibleStartDay + visibleWindowDays, durationDays))")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Button("Next ▶︎") { moveWeek(1) }
                            .buttonStyle(.bordered)
                            .disabled(visibleStartDay + visibleWindowDays >= durationDays)
                    }
                    .padding(.top, 4)
                }
                .simpleCard()

                if challengeOver {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Challenge is over")
                            .font(.headline)

                        Text("This challenge lasted \(durationDays) days. Start a new one to keep tracking.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Button("Start New Challenge") {
                            restartFromBeginning()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .simpleCard()
                } else {
                    Text("Start: \(startWeight, specifier: "%.1f")  •  Goal: \(targetWeight, specifier: "%.1f")  •  Weeks: \(totalWeeks)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding()
        }

        .safeAreaInset(edge: .top) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Daily Weigh-In")
                        .font(.largeTitle)
                        .bold()
                    Text("Enter today’s weight to track your progress.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                inputCard
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { weightFieldFocused = false }
            }
        }

        .onAppear {
            loadGoalNumbers()
            loadOrStartChallenge()
            refreshChallengeStatus()
            updateChartRange()
            visibleStartDay = 0
        }
    }

    private var inputCard: some View {
        HStack {
            TextField("Enter today's weight", text: $todayWeight)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .focused($weightFieldFocused)
                .disabled(challengeOver)

            Button("Add") {
                addTodayWeight()
                weightFieldFocused = false
            }
            .buttonStyle(.borderedProminent)
            .disabled(challengeOver)
        }
        .simpleCard()
    }

    private func loadGoalNumbers() {
        func toDouble(_ s: String) -> Double {
            let filtered = s.filter { "0123456789.".contains($0) }
            return Double(filtered) ?? 0
        }

        startWeight = toDouble(weightGoal.currentWeight)
        targetWeight = toDouble(weightGoal.goalWeight)
        totalWeeks = weightGoal.weeks
        miniGoal1Weight = toDouble(weightGoal.miniGoal1)
        miniGoal2Weight = toDouble(weightGoal.miniGoal2)
    }

    private func loadOrStartChallenge() {
        let stored = UserDefaults.standard.double(forKey: keyStartDate)

        if stored == 0 {
            challengeStartDate = Date()
            UserDefaults.standard.set(challengeStartDate.timeIntervalSince1970, forKey: keyStartDate)

            points = [WeightPoint(day: 0, weight: startWeight)]
            savePoints()
        } else {
            challengeStartDate = Date(timeIntervalSince1970: stored)
            loadPoints()

            if points.isEmpty {
                points = [WeightPoint(day: 0, weight: startWeight)]
                savePoints()
            }
        }
    }

    private func refreshChallengeStatus() {
        let endDate = Calendar.current.date(byAdding: .day, value: durationDays, to: challengeStartDate) ?? challengeStartDate
        challengeOver = Date() > endDate
    }

    private func updateChartRange() {
        let candidates = [startWeight, targetWeight, miniGoal1Weight, miniGoal2Weight].filter { $0 > 0 }
        let minVal = (candidates.min() ?? startWeight) - yPadding
        let maxVal = (candidates.max() ?? startWeight) + yPadding

        if minVal == maxVal {
            yMin = minVal - 1
            yMax = maxVal + 1
        } else {
            yMin = minVal
            yMax = maxVal
        }
    }

    private func addTodayWeight() {
        refreshChallengeStatus()
        if challengeOver { return }

        let cleaned = todayWeight.filter { "0123456789.".contains($0) }
        guard let value = Double(cleaned) else { return }

        let day = max(daysSinceChallengeStart(), 0)

        if let idx = points.firstIndex(where: { $0.day == day }) {
            points[idx] = WeightPoint(day: day, weight: value)
        } else {
            points.append(WeightPoint(day: day, weight: value))
            points.sort { $0.day < $1.day }
        }

        savePoints()
        todayWeight = ""
    }

    private func restartFromBeginning() {
        UserDefaults.standard.removeObject(forKey: keyStartDate)
        UserDefaults.standard.removeObject(forKey: keyPoints)

        challengeStartDate = Date()
        UserDefaults.standard.set(challengeStartDate.timeIntervalSince1970, forKey: keyStartDate)

        points = [WeightPoint(day: 0, weight: startWeight)]
        savePoints()

        challengeOver = false
        todayWeight = ""
        visibleStartDay = 0
    }

    private func daysSinceChallengeStart() -> Int {
        Calendar.current.dateComponents([.day], from: challengeStartDate, to: Date()).day ?? 0
    }

    private func moveWeek(_ delta: Int) {
        let next = visibleStartDay + (delta * 7)
        let clamped = min(max(next, 0), max(durationDays - visibleWindowDays, 0))
        visibleStartDay = clamped
    }

    private func savePoints() {
        if let data = try? JSONEncoder().encode(points) {
            UserDefaults.standard.set(data, forKey: keyPoints)
        }
    }

    private func loadPoints() {
        guard let data = UserDefaults.standard.data(forKey: keyPoints),
              let decoded = try? JSONDecoder().decode([WeightPoint].self, from: data) else {
            points = []
            return
        }
        points = decoded
    }
}

private extension View {
    func simpleCard() -> some View {
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

#Preview {
    NavigationStack {
        WeightGraph(
            weightGoal: Goal(
                currentWeight: "300",
                goalWeight: "250",
                weeks: 3,
                miniGoal1: "280",
                miniGoal2: "265",
                miniGoal3: "0",
                habit1: "",
                habit2: "",
                habit3: ""
            )
        )
        .navigationTitle("Progress")
    }
}
