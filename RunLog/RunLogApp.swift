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
        }
    }
}
