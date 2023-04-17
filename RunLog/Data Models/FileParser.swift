//
//  FileParser.swift
//  Profiles
//
//  Created by Camden Fritz on 2/6/23.
//

import Foundation


struct FileParser {
    var url: URL? = nil
    
    var runs: [Run] = []
    
    var separators = CharacterSet(charactersIn: ",")
    
    mutating func parseData() throws -> [Run.ID: Run] {
        var localData: [[String]] = []
        
        guard let unwrappedURL = url else {
            throw FileParserError.nilURL
        }
        
        // Get File Content
        guard let content = try getContentFrom(unwrappedURL) else {
            throw FileParserError.noDataAtURL(unwrappedURL)
        }
        
        // parseFile from Large String
        localData = try parseString(content, withSeparators: self.separators)
        self.runs = try updateRuns(localData)

        return Dictionary(uniqueKeysWithValues: runs.map { ($0.id,  $0) })
        
    }
    
    private func parseString(_ contentString: String, withSeparators separatorsIn: CharacterSet) throws -> [[String]] {
        var localData: [[String]] = []
        
        let lines = contentString.components(separatedBy: .newlines)
        
        // how many columns of data
        guard let firstLine = lines.first else {throw FileParserError.stringIsEmpty}
    
        let numberOfColumns = firstLine.components(separatedBy: separatorsIn).count
        
        for nextLine in lines[1...] {
            
            let rowData = nextLine.components(separatedBy: separatorsIn)
            
            if rowData == [""] {
                continue
            }
            
            if rowData.count != numberOfColumns {
                throw FileParserError.numberOfcolumnsShouldBeStatic
            }
            
            var tempData = [String]()
            for nextString in rowData {
                
                let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,./: ")
                let filteredText = String(nextString.unicodeScalars.filter(allowedCharacters.contains))
                
                tempData.append(filteredText)
                
            }
            localData.append(tempData)
        }
        
        return localData
    }
    
    
    private mutating func updateRuns(_ dataIn: [[String]]) throws -> [Run] {
        var runs: [Run] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        for runData in dataIn {
            guard let date = dateFormatter.date(from: String(runData[0])) else {
                throw FileParserError.incorrectDateFormat
            }
            guard let distance = Double(runData[1]) else {
                throw FileParserError.wrongDataInColumn
            }
            
            let timeComponents = runData[2].split(separator: ":")
            guard timeComponents.count == 3,
                  let hours = Double(timeComponents[0]),
                  let minutes = Double(timeComponents[1]),
                  let seconds = Double(timeComponents[2]) else {
                throw FileParserError.wrongDataInColumn
            }
            let duration = hours * 3600 + minutes * 60 + seconds
            
            let calories = Int(runData[3])
            let notes = runData[4].isEmpty ? "" : String(runData[4])
            let uuidString = runData[5].isEmpty ? nil : String(runData[5])
            
            let run = Run(date: date, distance: distance, duration: duration, calories: calories, notes: notes, uuidString: uuidString)
            runs.append(run)
            
        }
        
        return runs
    }
    
    
    private func getContentFrom(_ url: URL) throws -> String? {
        let filePath = url.path
        guard let contentData = FileManager.default.contents(atPath: filePath) else {throw FileParserError.noDataAtURL(url)}
        
        guard let contentString = String(data: contentData, encoding: .ascii) else {throw FileParserError.stringIsEmpty}
        
        return contentString
    }
    
}

extension FileParser {
    enum FileParserError: Error {
        case nilURL
        case noDataAtURL(URL)
        case stringCouldNotBeFormedFromDataAtURL(URL)
        case stringIsEmpty
        case noColumnsCreated
        case numberOfcolumnsShouldBeStatic
        case incorrectDateFormat
        case wrongDataInColumn
    }
}
