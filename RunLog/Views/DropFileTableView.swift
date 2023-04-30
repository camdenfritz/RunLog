//
//  DropFilesView.swift
//  Grades-2023
//
//  Created by Camden Fritz on 3/3/23.
//

import SwiftUI

struct DropFileTableView: View {
    
    @Binding var url: URL?
    @State var isHoveredOver = false
    @EnvironmentObject var runLogViewModel: RunLogViewModel
    @Binding var sortOrder: [KeyPathComparator<Run>]
    
    private var strokeBorderColor: Color {
        return isHoveredOver ? .blue : .gray
    }
    var body: some View {
        let dropDelegate = CSVURLDropDelegate(url: $url, isHoveredOver: $isHoveredOver)
        ZStack {
            RunLogTableView(
                sortOrder: $runLogViewModel.sortOrder)
                .environmentObject(runLogViewModel)
                
            Rectangle()
                .strokeBorder(strokeBorderColor, lineWidth: 2)
        }.onDrop(of: [.url], delegate: dropDelegate)
    }
    
    private func fileName() -> String {
        guard let localURL = url else {
            return "Drop File"
        }
        let fileName = localURL.lastPathComponent
        
        return fileName
    }
}

// MARK: - Drop Delegate
struct CSVURLDropDelegate: DropDelegate {
    @Binding var url: URL?
    @Binding var isHoveredOver: Bool
        
    func validateDrop(info: DropInfo) -> Bool {
        let state = info.hasItemsConforming(to: [.fileURL])
            
        return state
    }
        
    func dropEntered(info: DropInfo) {
        if info.hasItemsConforming(to: [.fileURL]) {
            isHoveredOver = true
        }
    }
    
    func dropExited(info: DropInfo) {
        isHoveredOver = false
    }
    
    func performDrop(info: DropInfo) -> Bool {
        Task {
            let localURL = await urlFrom(info)
            self.url = localURL
            isHoveredOver = false
        }
        return true
    }
    
    private func urlFrom(_ info: DropInfo) async -> URL? {
        guard let itemProviders = info.itemProviders(for: [.fileURL]).first else {return nil}
        
        return await withCheckedContinuation {continuation in
            
            itemProviders.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                guard let localURLData = urlData as? Data else {
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let localURL = URL(dataRepresentation: localURLData, relativeTo: nil) else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: localURL)
            }
        }
    }
    
 }

//struct DropFilesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DropFilesView()
//    }
//}
