//
//  RunLogApp.swift
//  RunLog
//
//  Created by Camden Fritz on 4/6/23.
//

import SwiftUI

@main
struct RunLogApp: App {
    @StateObject var runLogViewModel = RunLogViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(runLogViewModel)
        }.commands {
            CommandGroup(before: CommandGroupPlacement.newItem) {
                Button("Import Runs") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        runLogViewModel.url = panel.url
                    }
                }
                Button("Export Runs") {
                    let panel = NSSavePanel()
                    panel.canCreateDirectories = true
                        
                    if panel.runModal() == .OK {
                        if let url = panel.url {
                            runLogViewModel.exportData(exportToUrl: url)
                        }
                    }
                }
            }
        }

    }
}
