//
//  Day.swift
//  RunLog
//
//  Created by Camden Fritz on 4/26/23.
//

import Foundation

enum Day: String, CaseIterable {
    case Sunday    = "Sun"
    case Monday    = "Mon"
    case Tuesday   = "Tue"
    case Wednesday = "Wed"
    case Thursday  = "Thur"
    case Friday    = "Fri"
    case Saturday  = "Sat"
    
    var intValue: Int {
        switch self {
        case .Sunday:
            return 0
        case .Monday:
            return 1
        case .Tuesday:
            return 2
        case .Wednesday:
            return 3
        case .Thursday:
            return 4
        case .Friday:
            return 5
        case .Saturday:
            return 6
        }
    }
}
