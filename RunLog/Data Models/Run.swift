//
//  run.swift
//  RunLog
//
//  Created by Camden Fritz on 4/6/23.
//

import Foundation


class Run: Identifiable, Hashable, ObservableObject {
    var date: Date
    var distance: Double {
        didSet {
            setPace()
        }
    }
    var duration: Double {
        didSet {
            setPace()
        }
    }// seconds

    var calories: Int?
    var notes: String
    var pace: Double // seconds a mile
    var isMetric = false
    var id: Run.ID
    
    init(date: Date, distance: Double, duration: Double, calories: Int? = nil, notes: String = "", uuidString : String?) {
        self.date = date
        self.distance = distance
        self.duration = duration
        self.calories = calories
        self.notes = notes
        self.id = Run.ID(uuidString: uuidString)
        if distance == 0.0 || duration == 0.0 {
            self.pace = 0
        } else {
            self.pace = self.duration / self.distance
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    struct ID: Identifiable, Hashable {
        let id: UUID
        
        init(uuidString: String? = nil) {
            guard let tempString = uuidString else {
                self.id = UUID()
                return
            }
            let tempId = UUID(uuidString: tempString)
            if let id = tempId {
                self.id = id
            } else {
                self.id = UUID()
            }
        }
    }
    
    func setPace() {
        if distance == 0.0 || duration == 0.0 {
            pace = 0
        } else {
            self.pace = self.duration / self.distance
        }
    }
}

extension Run: Equatable {
    static func == (lhs: Run, rhs: Run) -> Bool {
        return lhs.id == rhs.id
    }
}
