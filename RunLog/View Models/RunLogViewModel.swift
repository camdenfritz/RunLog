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
    
    @Published var selectedRun: Run?
    
    init() {
        guard let exampleRunLog = Bundle.main.url(forResource: "RunLog", withExtension: "csv") else {
            exit(-1)
        }
        
        url = exampleRunLog
        parseData()
        updateState()
    }
    
    func parseData() {
        var parser = FileParser(url: self.url)
        
        do {
            let parsedData = try parser.parseData()
            runLog.runs = parsedData
        } catch {
            print(error)
        }
    }
    
    func updateState() {
        runs = Array(runLog.runs.values).sorted(using: sortOrder)
    }
}
