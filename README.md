# 📉 Lean-Line

Lean Line is a SwiftUI-based iOS weight tracking app built in **Swift Playgrounds**.  
It helps users set a clear weight goal, build small daily habits, and visually track progress over time.

Built by **Mohamed Kaid**

---

## 🚀 Features

- Create a personalized weight goal  
- Set starting weight and target weight  
- Select small daily habit goals  
- Log daily weight entries  
- Dynamic progress graph using Swift Charts  
- Goal reference line for visual tracking  
- Automatic local persistence  
- Reset and create a new plan anytime  

---

## 📱 Screenshots

### 📝 Create Plan
<img width="230" height="600" alt="Screenshot 2026-03-11 at 10 27 53 AM" src="https://github.com/user-attachments/assets/227f6032-16e3-42f0-bca9-c39437d93458" />
<img width="230" height="600" alt="Screenshot 2026-03-11 at 10 28 09 AM" src="https://github.com/user-attachments/assets/8f8f041c-2955-42f3-afdb-3f5942418a52" />

### 📊 Progress Graph
<img width="230" height="600" alt="Screenshot 2026-03-11 at 10 27 06 AM" src="https://github.com/user-attachments/assets/779606a0-fd57-4eee-b223-0085a8909853" />

### ✅ Habit Checker
<img width="230" height="600" alt="Screenshot 2026-03-11 at 10 27 23 AM" src="https://github.com/user-attachments/assets/f1121aad-4215-4e39-bc27-22ad61fe5e8b" />

### ⚙️ Settings
<img width="230" height="600" alt="Screenshot 2026-03-11 at 10 27 35 AM" src="https://github.com/user-attachments/assets/b6b0a677-0016-46e7-a096-0d85ddbe2f20" />


---

## 🧱 Architecture

- SwiftUI  
- Single-plan data model  
- `@State` & `@Binding` state management  
- Codable + UserDefaults local storage  
- Swift Charts  

---

## 💾 Data Storage

The user’s goal and progress are encoded using `Codable` and stored locally with `UserDefaults`.  
The app automatically restores the saved plan on launch.

---

## 📈 Tracking System

- Users log weight daily  
- The graph updates in real time  
- A dashed goal line shows the target weight  
- Progress is calculated across the selected time period  

---

## 🛠 Tech Stack

Swift • SwiftUI • Swift Charts • Codable • UserDefaults • Swift Playgrounds

---

## 🎯 Purpose

Designed for individuals who want a minimal, distraction-free way to track weight progress and stay consistent with small daily habit improvements.

Lean Line emphasizes clarity, simplicity, and visual motivation.
