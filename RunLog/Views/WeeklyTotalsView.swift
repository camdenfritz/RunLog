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
                        let daysAgo = (weeklyMileage.count - index) * -7
                        if let dayOfWeek = Calendar.current.date(byAdding: .day, value: daysAgo, to: Date()) {
                            let weekStr = WeeklyTotalsView.dateFormatter.string(from: dayOfWeek)
                            LineMark(
                                x: .value("Week", "\(weekStr.dropLast(5))"),
                                y: .value("Mileage", week)
                            )
                        }
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
                                if var tempSelectedWeek = selectedWeek {
                                    tempSelectedWeek += "-"
                                    tempSelectedWeek += String(Calendar.current.component(.year, from: Date()))
                                    if let selectedDay = WeeklyTotalsView.dateFormatter.date(from: tempSelectedWeek) {
                                        let components = Calendar.current.dateComponents([.day], from: selectedDay, to: Date())
                                        let tempIndex = weeklyMileage.count - Int((components.day ?? 0)/7)
                                        if tempIndex > 0 && tempIndex < weeklyMileage.count {
                                            selectedIndex = tempIndex
                                        }                                        
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
}
