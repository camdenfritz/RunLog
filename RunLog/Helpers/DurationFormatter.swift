//
//  DurationFormatter.swift
//  RunLog
//
//  Created by Camden Fritz on 4/24/23.
//

import Foundation

class DurationFormatter: Formatter {
    
    // Friend at OpenAI wrote this for me
    override func string(for obj: Any?) -> String? {
        guard let duration = obj as? Double else { return nil }
        
        let hours = Int(duration / 3600)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let components = string.split(separator: ":").map { Double($0) ?? 0 }
        
        if components.count == 3 {
            let duration = components[0] * 3600 + components[1] * 60 + components[2]
            obj?.pointee = duration as AnyObject
            return true
        }
        
        error?.pointee = "Invalid duration format. Expected format: HH:mm:ss" as NSString
        return false
    }
}
