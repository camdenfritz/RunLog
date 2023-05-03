//
//  StatsView.swift
//  RunLog
//
//  Created by Camden Fritz on 5/3/23.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var viewModel: RunLogViewModel
    @State private var selectedNumberOfDays: Int = 7 {
        didSet {
            print("here")
        }
    }
    let dayChoices = [7, 30, 90]
    
    var body: some View {
        
        HStack {
            createStatsCard(title: "Total Miles", stat: String(format: "%.2f", viewModel.calculateStats(past: selectedNumberOfDays).totalMiles))
            createStatsCard(title: "Daily Average", stat: "\(String(format: "%.2f", viewModel.calculateStats(past: selectedNumberOfDays).dailyAverage)) miles")
            createStatsCard(title: "Average Pace", stat: paceText(for: viewModel.calculateStats(past: selectedNumberOfDays).averagePace))

            
            Picker("Stats Duration", selection: $selectedNumberOfDays) {
                ForEach(dayChoices, id: \.self) { day in
                    Text(String(day))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
    }
}

func createStatsCard(title: String, stat: String) -> some View {
    return VStack {
        Text(title)
            .font(.headline)
            .padding(.bottom, 8)
            .padding(.top, 8)
        Divider()
        Text("\(stat)")
        Spacer()
    }
    .padding()
    .background(Color.gray.opacity(0.2))
    .cornerRadius(10)
}

private func paceText(for run: Double) -> String {
    let totalSeconds = Int(run)
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d:%02d /mi", minutes, seconds)
}
