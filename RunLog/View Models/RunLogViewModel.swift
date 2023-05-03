//
//  RunLogViewModel.swift
//  RunLog
//
//  Created by Camden Fritz on 4/9/23.
//

import Foundation

class RunLogViewModel: ObservableObject {
    @Published var url: URL? = nil {
        didSet {
            parseData()
        }
    }
    
    @Published var runLog  = RunLog()
    
    @Published var runs: [Run] = []
    
    @Published var sortOrder: [KeyPathComparator<Run>] = [.init(\.date, order: .forward)] {
        didSet {
            updateState()
        }
    }
    
    @Published var thisWeekMileage: [Double] = [Double](repeating: 0.0, count: 7)
    
    @Published var pastTenWeekMileage: [Double] = [Double](repeating: 0.0, count: 10)

    @Published var pastTenWeekDuration: [Double] = [Double](repeating: 0.0, count: 10)

    
    @Published var selectedRun: Run.ID? {
        didSet {

            updateState()
        }
    }
    
    init() {
        
        if let savedRunLog = UserDefaults.standard.data(forKey: "runLog") {
            let decoder = JSONDecoder()
            if let loadedRunLog = try? decoder.decode(RunLog.self, from: savedRunLog) {
                self.runLog = loadedRunLog
            }
        } else {
            guard let exampleRunLog = Bundle.main.url(forResource: "RunLog", withExtension: "csv") else {
                exit(-1)
            }
            url = exampleRunLog
        }
        updateState()
    }
    
    func addRun(newRun: Run) {
        runLog.runs[newRun.id] = newRun
        updateState()
    }
    
    func parseData() {
        var parser = FileParser(url: self.url)
        
        do {
            let parsedData = try parser.parseData()
            for (id, run) in parsedData {
                if runLog.runs[id] == nil {
                    runLog.runs[id] = run
                }
            }
        } catch {
            print(error)
        }
        updateState()
    }
    
    func updateState() {
        runs = Array(runLog.runs.values).sorted(using: sortOrder)
        calculateThisWeekMileage()
        sumMileageOfPastNWeeks(10)
        saveRunLog()
    }
    
    func deleteRun(run: Run.ID) {
        runLog.deleteRun(runID: run)
        updateState()
    }
    
    func exportData(exportToUrl: URL) {
        let parser = FileParser(url: self.url)
        
        do {
            try parser.exportToCSV(runs: runs, url: exportToUrl)
        } catch {
            print(error)
        }
        updateState()
    }
    
    func calculateThisWeekMileage() {
        let today = Calendar.current.component(.weekday, from: Date())
        thisWeekMileage = Array(repeating: 0.0, count: 7)
        
        for i in -today+1..<8-today {
            let dayTemp = Calendar.current.date(byAdding: .day, value: i, to: Date())
            guard let day = dayTemp else {
                continue
            }
            for run in runs {
                if isSameDay(date1: run.date, date2: day) {
                    thisWeekMileage[i+today-1] += run.distance
                }
            }
            
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year, .month, .day], from: date1)
        let components2 = Calendar.current.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
    }
    
    func sumMileageOfPastNWeeks(_ numberWeeks: Int) {
        pastTenWeekMileage = Array(repeating: 0, count: numberWeeks)
        pastTenWeekDuration = Array(repeating: 0, count: numberWeeks)
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // 1 means Sunday

        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))

        for run in runs {
            let runWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: run.date))
            let weekDifference = calendar.dateComponents([.weekOfYear], from: runWeek!, to: startOfWeek!).weekOfYear
            guard let weeksAgo = weekDifference else { continue }
            
            if weeksAgo >= 0 && weeksAgo < numberWeeks {
                pastTenWeekMileage[weeksAgo] += run.distance
                pastTenWeekDuration[weeksAgo] += run.duration
            }
        }
        
        pastTenWeekMileage.reverse()
        pastTenWeekDuration.reverse()
    }
    
    private func saveRunLog() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(runLog) {
            UserDefaults.standard.set(encoded, forKey: "runLog")
        }
    }

}


/// Stats extension
extension RunLogViewModel {
    struct Stats {
        let totalMiles: Double
        let dailyAverage: Double
        let averagePace: Double
    }
    
    func calculateStats(past pastDays: Int) -> Stats {
        let today = Date()
        let startDay = Calendar.current.date(byAdding: .day, value: -pastDays, to: today)!
        
        var totalMiles = 0.0
        var totalDuration = 0.0
        var numberOfRuns = 0.0
        var totalPace = 0.0
        
        for run in runs {
            if run.date >= startDay && run.date <= today {
                totalMiles += run.distance
                totalDuration += run.duration
                totalPace += run.pace
                numberOfRuns += 1
            }
        }
        
        let dailyAverage = totalMiles / Double(pastDays)
        let averagePace = numberOfRuns > 0 ? totalPace / numberOfRuns : 0
        
        return Stats(totalMiles: totalMiles, dailyAverage: dailyAverage, averagePace: averagePace)
    }
}
