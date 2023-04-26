//
//  EditLogView.swift
//  RunLog
//
//  Created by Camden Fritz on 4/9/23.
//

import SwiftUI

struct EditRunView: View {
    @Binding var run: Run
    
    var body: some View {
        VStack {
            Form {
                DatePicker("Date", selection: $run.date, displayedComponents: .date)
                
                TextField("Distance (miles)", value: $run.distance, format: .number)
                
                TextField("Duration (HH:mm:ss)", value: $run.duration, formatter: DurationFormatter())
                
                TextField("Calories (optional)", value: $run.calories, format: .number)
                
                TextField("Notes (optional)", text: $run.notes)
            }
        }
        .padding()
        
    }
}
