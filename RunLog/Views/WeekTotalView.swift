//
//  WeekTotalView.swift
//  RunLog
//
//  Created by Camden Fritz on 4/25/23.
//

import SwiftUI
import Charts

struct WeekTotalView: View {
    
    @Binding var weekMileage: [Double]
    @State private var selectedDay: String?

    var body: some View {
        VStack(alignment: .leading) {
            GroupBox ("This Week's Mileage") {
                Chart {
                    ForEach(Day.allCases, id: \.intValue) { day in
                        BarMark(
                            x: .value("Day of the Week", day.rawValue),
                            y: .value("Mileage", weekMileage[day.intValue])
                        )
                    }
                    if let selectedDay {
                        RectangleMark(x: .value("Day", selectedDay))
                            .foregroundStyle(.primary.opacity(0.2))
                            .annotation(
                                position: .leading,
                                alignment: .center, spacing: 0
                            ) {
                                Text(String(format: "%.2f", weekMileage[Day(rawValue: selectedDay)?.intValue ?? 0]))
                            }
                    }
                }
                .chartOverlay { (chartProxy: ChartProxy) in
                    Color.clear
                        .onContinuousHover { hoverPhase in
                            switch hoverPhase {
                            case .active(let hoverLocation):
                                selectedDay = chartProxy.value(
                                    atX: hoverLocation.x, as: String.self
                                )
                            case .ended:
                                selectedDay = nil
                            }
                        }
                }
                .padding()
            }
        }
    }
}
