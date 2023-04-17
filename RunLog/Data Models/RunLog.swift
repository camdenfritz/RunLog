//
//  RunLog.swift
//  RunLog
//
//  Created by Camden Fritz on 4/10/23.
//

import Foundation

class RunLog: ObservableObject {
    var runs: [Run.ID: Run] = [:]
    
    func deleteRun(runID: Run.ID) {
        runs.removeValue(forKey: runID)
    }
}
