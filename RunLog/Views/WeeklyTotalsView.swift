//
//  WeekTotalView.swift
//  RunLog
//
//  Created by Camden Fritz on 4/25/23.
//

import SwiftUI
import Charts

struct WeeklyTotalsView: View {
    
    @Binding var weeklyMileage: [Double]
    @Binding var weeklyDuration: [Double]
    @State private var selectedWeek: String?
    @State private var selectedIndex: Int = 0
    
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()


    var body: some View {
        VStack(alignment: .leading) {
            GroupBox ("Weekly Mileage") {
                WeeklyStats(weeklyMileage: $weeklyMileage, weeklyDuration: $weeklyDuration, selectedWeekIndex: $selectedIndex)
                Chart {
                    ForEach(Array(zip(weeklyMileage.indices, weeklyMileage)), id: \.0) { index, week in
                            LineMark(
                                x: .value("Week", "\(makeStrDate(index: index))"),
                                y: .value("Mileage", week)
                            )
                        }
                    if let selectedWeek {
                        PointMark(x: .value("Week", selectedWeek),
                                  y: .value("Mileage", weeklyMileage[selectedIndex]))
                        
                    }
                }
                .chartOverlay { (chartProxy: ChartProxy) in
                    Color.clear
                        .onContinuousHover { hoverPhase in
                            switch hoverPhase {
                            case .active(let hoverLocation):
                                selectedWeek = chartProxy.value(
                                    atX: hoverLocation.x, as: String.self
                                )
                                for (index, weekStr) in weeklyMileage.indices.map({ i in makeStrDate(index: i) }).enumerated() {
                                    if weekStr == selectedWeek {
                                        selectedIndex = index
                                        break
                                    }
                                }
                            case .ended:
                                selectedWeek = nil
                                selectedIndex = weeklyMileage.count - 1
                            }
                        }
                }
                .padding()
            }
        }
    }
    func makeStrDate(index: Int) -> String {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // 1 means Sunday
        let today = Date()
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else { return "" }
        let weekStartIndexAgo = calendar.date(byAdding: .weekOfYear, value: -(weeklyMileage.count-index-1), to: startOfWeek)

        guard let weekStart = weekStartIndexAgo else {
            return ""
        }
        
        let weekStr = WeeklyTotalsView.dateFormatter.string(from: weekStart)
        let trimmedWeekStr = String(weekStr.dropLast(5))
        return trimmedWeekStr
    }
}

