//
//  EditLogView.swift
//  RunLog
//
//  Created by Camden Fritz on 4/9/23.
//

import SwiftUI

struct EditRunView: View {
    @Binding var run: Run
    @EnvironmentObject var runLogViewModel: RunLogViewModel
    
    @State private var selectedDate = Date()
    @State private var duration = ""
    
    @State private var isDistanceValid = true
    @State private var isDurationValid = true
    
    var body: some View {
        VStack {
            Form {
                DatePicker("Date", selection: $run.date, displayedComponents: .date)
                    .onAppear {
                        self.selectedDate = run.date
                    }
                
                TextField("Distance (miles)", value: $run.distance, format: .number)
                
                TextField("Duration (HH:mm:ss)", text: $duration)
                    .onAppear {
                        let hours = Int(run.duration / 3600)
                        let minutes = Int((run.duration.truncatingRemainder(dividingBy: 3600)) / 60)
                        let seconds = Int(run.duration.truncatingRemainder(dividingBy: 60))
                        self.duration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                    }
                    .onChange(of: duration) { value in
                        isDurationValid = validateDuration(value)
                        if isDurationValid {
                            let timeComponents = duration.split(separator: ":").map { Double($0) ?? 0 }
                            run.duration = timeComponents[0] * 3600 + timeComponents[1] * 60 + timeComponents[2]
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 2)
                        .stroke(isDurationValid ? Color.clear : Color.red, lineWidth: 2))
                
                TextField("Calories (optional)", value: $run.calories, format: .number)
                
                TextField("Notes (optional)", text: $run.notes)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save", action: {
                        if !runLogViewModel.runs.contains(run) {
                            runLogViewModel.runs.append(run)
                        }
                        runLogViewModel.selectedRun = nil
                    })
                    .disabled(!isDurationValid)
                }
            }
        }
        .padding()
        
    }
    
    private func validateDuration(_ duration: String) -> Bool {
        let components = duration.split(separator: ":")
        if components.count == 3 {
            // Ensure that hours, minutes, and seconds are valid integers within the appropriate ranges
            if let hours = Int(components[0]), hours >= 0,
               let minutes = Int(components[1]), minutes >= 0 && minutes < 60,
               let seconds = Int(components[2]), seconds >= 0 && seconds < 60 {
                return true
            }
        }
        return false
    }
}
