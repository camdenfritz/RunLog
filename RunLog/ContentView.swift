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

    var body: some View {
        VStack {
            NavigationView {
                RunLogTableView(sortOrder: $runLogViewModel.sortOrder)
                    .environmentObject(runLogViewModel)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("New", action: {
                                if runLogViewModel.selectedRun == nil {
                                    
                                    newRun = Run(date: Date(), distance: 0, duration: 0, uuidString: nil)
                                    runLogViewModel.selectedRun = newRun
                                }
                            })
                            .disabled(runLogViewModel.selectedRun != nil)
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
                
                if let selectedRun = runLogViewModel.selectedRun,
                   let runIndex = runLogViewModel.runs.firstIndex(where: { $0.id == selectedRun.id }) {
                    EditRunView(run: $runLogViewModel.runs[runIndex])
                        .environmentObject(runLogViewModel)
                        .padding()
                        .navigationTitle("Edit Run")
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button("Cancel", action: {
                                    runLogViewModel.selectedRun = nil
                                })
                            }
                        }
                } else if runLogViewModel.selectedRun != nil {
                    EditRunView(run: $newRun)
                        .environmentObject(runLogViewModel)
                        .padding()
                        .navigationTitle("New Run")
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button("Cancel", action: {
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
        }
    }
}

