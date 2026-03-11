//
//  MainTabsView.swift
//  WeightGoals
//
//  Created by Mohamed Kaid on 2/24/26.
//

import SwiftUI

struct MainTabsView: View {
    @Binding var goals: [Goal]

    var body: some View {
        // no optionals: pick index 0 if it exists, otherwise fallback
        let currentGoal = goals.isEmpty
        ? Goal(currentWeight: "0", goalWeight: "0", weeks: 1,
               miniGoal1: "0", miniGoal2: "0", miniGoal3: "0",
               habit1: "", habit2: "", habit3: "")
        : goals[0]

        TabView {
            WeightGraph(weightGoal: currentGoal)
                .tabItem {
                    Label("Graph", systemImage: "chart.line.uptrend.xyaxis")
                }

            HabitsCheckerView(goal: currentGoal)
                .tabItem {
                    Label("Habits", systemImage: "checklist")
                }

            SettingsView(goals: $goals, currentGoal: currentGoal)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
