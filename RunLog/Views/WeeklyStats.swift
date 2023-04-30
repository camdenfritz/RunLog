//
//  WeeklyStats.swift
//  RunLog
//
//  Created by Camden Fritz on 4/28/23.
//

import SwiftUI

struct WeeklyStats: View {
    @Binding var weeklyMileage: [Double]
    @Binding var weeklyDuration: [Double]
    @Binding var selectedWeekIndex: Int

    let formatter = DurationFormatter()

    var body: some View {
        VStack {
            getWeekString(from: selectedWeekIndex)
                .font(.headline)
                .padding(.bottom, 8)
                .padding(.top, 8)
            Divider()
            Text("Distance: \(String(format: "%.2f", weeklyMileage[selectedWeekIndex]))mi")
            Spacer()
            Text("Duration: \(durationText(run: weeklyDuration[selectedWeekIndex]))")
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    private func durationText(run: Double) -> String {
        let hours = Int(run / 3600)
        let minutes = Int((run.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(run.truncatingRemainder(dividingBy: 60))
        
        if hours == 0 {
            return String(format: "%02dm %02ds", minutes, seconds)
        } else {
            return String(format: "%2dh %02dm", hours, minutes)
        }
    }
    
    func getWeekString(from index: Int) -> some View {
        if (weeklyMileage.count - index - 1) == 0 {
            return Text("This Week")
        }
        let daysAgo = (weeklyMileage.count - index - 1) * -7
        let date = Calendar.current.date(byAdding: .day, value: daysAgo, to: Date())
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        
        let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date!))
        let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        let weekStartString = dateFormatter.string(from: weekStartDate!)
        let weekEndString = dateFormatter.string(from: weekEndDate!)
        
        return Text("Week of \(weekStartString) - \(weekEndString)")
    }
}

