//
//  ContentView.swift
//  RunLog
//
//  Created by Camden Fritz on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var runLogViewModel = RunLogViewModel()
    var body: some View {
        VStack {
            NavigationView {
                RunLogTableView(sortOrder: $runLogViewModel.sortOrder)
                    .environmentObject(runLogViewModel)
                
                if let selectedRun = runLogViewModel.selectedRun,
                   let runIndex = runLogViewModel.runs.firstIndex(where: { $0.id == selectedRun.id }) {
                    EditRunView(run: $runLogViewModel.runs[runIndex])
                        .padding()
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
        }
    }
}

