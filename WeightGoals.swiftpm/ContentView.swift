//
//  ContentView.swift
//  GOALS
//
//  Created by Mohamed Kaid on 1/23/26.
//

import SwiftUI

struct ContentView: View {
    @State private var goals: [Goal] = []

    private let saveKey = "savedGoal_v1"

    var body: some View {
        NavigationStack {
            if goals.isEmpty {
                AddGoal(goals: $goals)
            } else {
                MainTabsView(goals: $goals)
            }
        }
        .onAppear {
            loadGoal()
        }
        .onChange(of: goals) { _ in
            saveGoal()
        }
    }

    private func saveGoal() {
        // Save only ONE plan
        if goals.isEmpty {
            UserDefaults.standard.removeObject(forKey: saveKey)
            return
        }

        let goalToSave = goals[0]

        if let data = try? JSONEncoder().encode(goalToSave) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadGoal() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode(Goal.self, from: data)
        else {
            goals = []
            return
        }

        goals = [saved]
    }
}

#Preview {
    ContentView()
}
