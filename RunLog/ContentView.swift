//
//  ContentView.swift
//  RunLog
//
//  Created by Camden Fritz on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var runLogViewModel: RunLogViewModel
    @State var newRun = Run(date: Date(), distance: 0, duration: 0, uuidString: nil)
    @State private var selectedEventID: Run.ID?

    var body: some View {
        VStack {
            NavigationView {
                RunLogTableView(
                    sortOrder: $runLogViewModel.sortOrder)
                    .environmentObject(runLogViewModel)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("New", action: {
                                newRun = Run(date: Date(), distance: 0, duration: 0, uuidString: nil)
                                runLogViewModel.addRun(newRun: newRun)
                                runLogViewModel.selectedRun = newRun.id
                            })
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button("Delete", action: {
                                if let selectedRun = runLogViewModel.selectedRun {
                                    runLogViewModel.deleteRun(run: selectedRun)
                                }
                                runLogViewModel.selectedRun = nil
                            })
                            .disabled(runLogViewModel.selectedRun == nil)
                        }
                    }
                
                if let selectedRunId = runLogViewModel.selectedRun,
                   let runIndex = runLogViewModel.runs.firstIndex(where: { $0.id == selectedRunId }) {
                    EditRunView(run: $runLogViewModel.runs[runIndex])
                        .environmentObject(runLogViewModel)
                        .padding()
                        .navigationTitle("Edit Run")
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button("Done", action: {
                                    runLogViewModel.selectedRun = nil
                            })
                        }
                    }
                } else {
                    Text("Select a run to edit")
                        .font(.title)
                        .foregroundColor(.gray)
                        .frame(width: 350)
                }
            }
            WeekTotalView(weeklyMileage: $runLogViewModel.thisWeekMileage)
        }
    }
}

