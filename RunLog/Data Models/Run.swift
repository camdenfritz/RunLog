//
//  run.swift
//  RunLog
//
//  Created by Camden Fritz on 4/6/23.
//

import Foundation


class Run: Identifiable, Hashable, ObservableObject, Codable {
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
    }

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
    enum CodingKeys: CodingKey {
            case date, distance, duration, calories, notes, pace, isMetric, id
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        distance = try container.decode(Double.self, forKey: .distance)
        duration = try container.decode(Double.self, forKey: .duration)
        calories = try container.decodeIfPresent(Int.self, forKey: .calories)
        notes = try container.decode(String.self, forKey: .notes)
        pace = try container.decode(Double.self, forKey: .pace)
        isMetric = try container.decode(Bool.self, forKey: .isMetric)
        id = try container.decode(Run.ID.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(distance, forKey: .distance)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(calories, forKey: .calories)
        try container.encode(notes, forKey: .notes)
        try container.encode(pace, forKey: .pace)
        try container.encode(isMetric, forKey: .isMetric)
        try container.encode(id, forKey: .id)
    }
        
    
    struct ID: Identifiable, Hashable, Codable {
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
