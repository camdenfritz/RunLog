//
//  RunLog.swift
//  RunLog
//
//  Created by Camden Fritz on 4/10/23.
//

import Foundation

class RunLog: ObservableObject, Codable {
    var runs: [Run.ID: Run] = [:]
    
    func deleteRun(runID: Run.ID) {
        runs.removeValue(forKey: runID)
    }
    
    enum CodingKeys: CodingKey {
        case runs
    }
    
    init() {
        runs = [:]
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        runs = try container.decode([Run.ID: Run].self, forKey: .runs)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(runs, forKey: .runs)
    }
}
