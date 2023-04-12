//
//  run.swift
//  RunLog
//
//  Created by Camden Fritz on 4/6/23.
//

import Foundation


class Run: Identifiable {
    var date: Date
    var distance: Double
    var duration: Double // seconds
    var calories: Int?
    var notes: String?
    var pace: Double // seconds a mile
    var isMetric = false
    var id: Run.ID
    
    
    init(date: Date, distance: Double, duration: Double, calories: Int? = nil, notes: String? = nil, uuidString : String?) {
        self.date = date
        self.distance = distance
        self.duration = duration
        self.pace = self.duration / self.distance
        self.calories = calories
        self.notes = notes
        self.id = Run.ID(uuidString: uuidString)
    }
    
    struct ID: Identifiable, Hashable {
        let id: UUID
        
        init(uuidString: String? = nil) {
            if let tempID = UUID(uuidString: uuidString ?? "") {
                self.id = tempID
            } else {
                self.id = UUID()
            }
        }
    }
}

extension Run: Equatable {
    static func == (lhs: Run, rhs: Run) -> Bool {
        return lhs.id == rhs.id
    }
}
