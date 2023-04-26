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
    
    var runLog  = RunLog()
    
    @Published var runs: [Run] = []
    
    @Published var sortOrder: [KeyPathComparator<Run>] = [.init(\.date, order: .forward)] {
        didSet {
            updateState()
        }
    }
    
    @Published var thisWeekMileage: [Double] = [Double](repeating: 0.0, count: 7)

    
    @Published var selectedRun: Run.ID?
    
    init() {
        guard let exampleRunLog = Bundle.main.url(forResource: "RunLog", withExtension: "csv") else {
            exit(-1)
        }
        
        url = exampleRunLog
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

}
