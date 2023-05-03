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
    @State var multipleSelection = Set<Run.ID>()

    var body: some View {
        VStack {
            HSplitView {
                DropFileTableView(url: $runLogViewModel.url, sortOrder: $runLogViewModel.sortOrder, multipleSelection: $multipleSelection)
                    .environmentObject(runLogViewModel)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("New", action: {
                                newRun = Run(date: Date(), distance: 0, duration: 0, uuidString: nil)
                                runLogViewModel.addRun(newRun: newRun)
                                multipleSelection = multipleSelection
                                multipleSelection = Set<Run.ID>()
                                multipleSelection.insert(newRun.id)
                            })
                        }
                    }
                    .frame(minHeight: 300)
                
                if let selectedRunId = multipleSelection.first {
                    if let runIndex = runLogViewModel.runs.firstIndex(where: { $0.id == selectedRunId }) {
                        EditRunView(run: $runLogViewModel.runs[runIndex])
                            .environmentObject(runLogViewModel)
                            .padding()
                            .navigationTitle("Edit Run")
                            .frame(minWidth: 300, minHeight: 300)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button("Done", action: {
                                        multipleSelection = Set<Run.ID>()
                                    })
                                }
                            }
                    }
                } else {
                    Text("Select a run to edit")
                        .font(.title)
                        .foregroundColor(.gray)
                        .frame(minWidth: 300, minHeight: 300)
                        .padding()
                }
            }
            Divider()
            HSplitView {
                WeekTotalView(weekMileage: $runLogViewModel.thisWeekMileage)
                    .frame(minHeight: 300)
                WeeklyTotalsView(weeklyMileage: $runLogViewModel.pastTenWeekMileage, weeklyDuration: $runLogViewModel.pastTenWeekDuration)
                    .frame(minHeight: 300)
            }
        }
    }
}

