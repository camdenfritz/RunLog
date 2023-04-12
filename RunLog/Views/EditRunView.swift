//
//  EditLogView.swift
//  RunLog
//
//  Created by Camden Fritz on 4/9/23.
//

import SwiftUI

struct EditRunView: View {
    @Binding var run: Run
    
    @State private var selectedDate = Date()
    @State private var distance = ""
    @State private var duration = ""
    @State private var calories = ""
    @State private var notes = ""
    
    var body: some View {
        VStack {
            
            Form {
                // TODO: Make fields red if required or wrong format
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .onAppear {
                        self.selectedDate = run.date
                    }
                
                TextField("Distance (miles)", text: $distance)
                    .onAppear {
                        self.distance = String(run.distance)
                    }
                
                TextField("Duration (HH:mm:ss)", text: $duration)
                    .onAppear {
                        let hours = Int(run.duration / 3600)
                        let minutes = Int((run.duration.truncatingRemainder(dividingBy: 3600)) / 60)
                        let seconds = Int(run.duration.truncatingRemainder(dividingBy: 60))
                        self.duration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                    }
                
                TextField("Calories (optional)", text: $calories)
                    .onAppear {
                        if let runCalories = run.calories {
                            self.calories = String(runCalories)
                        }
                    }
                
                TextField("Notes (optional)", text: $notes)
                    .onAppear {
                        self.notes = run.notes ?? ""
                    }
            }
            .navigationTitle("Edit Run")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save", action: saveRun)
                }
            }
        }
        .padding()
        
    }
    
    private func saveRun() {
        // Convert the duration from HH:mm:ss format to seconds
        let timeComponents = duration.split(separator: ":").map { Double($0) ?? 0 }
        let durationInSeconds = timeComponents[0] * 3600 + timeComponents[1] * 60 + timeComponents[2]
        
        // Save the edited values
        run.date = selectedDate
        run.distance = Double(distance) ?? 0
        run.duration = durationInSeconds
        run.pace = durationInSeconds / (Double(distance) ?? 0)
        run.calories = Int(calories)
        run.notes = notes.isEmpty ? nil : notes
    }
}
