//
//  Goal.swift
//  WeightGoals
//
//  Created by Mohamed Kaid on 1/30/26.
//

import Foundation

struct Goal: Identifiable, Codable, Equatable {
    var id: UUID = UUID()

    var currentWeight: String
    var goalWeight: String
    var weeks: Int

    var miniGoal1: String
    var miniGoal2: String
    var miniGoal3: String

    var habit1: String
    var habit2: String
    var habit3: String

    static let empty = Goal(
        currentWeight: "",
        goalWeight: "",
        weeks: 1,
        miniGoal1: "",
        miniGoal2: "",
        miniGoal3: "",
        habit1: "",
        habit2: "",
        habit3: ""
    )
}
