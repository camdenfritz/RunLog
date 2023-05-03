import SwiftUI

struct RunLogTableView: View {
    @EnvironmentObject var runLogViewModel: RunLogViewModel
    @Binding var sortOrder: [KeyPathComparator<Run>]
    
    @Binding var multipleSelection: Set<Run.ID>

    
    var body: some View {
        
        Table(runLogViewModel.runs,
              selection: $multipleSelection,
              sortOrder: $sortOrder) {
            TableColumn("Date", value: \.date) { run in
                dateText(for: run)
            }
            TableColumn("Distance", value: \.distance) { run in
                distanceText(for: run)
            }
            TableColumn("Duration", value: \.duration) { run in
                durationText(for: run)
            }
            TableColumn("Pace", value: \.pace) { run in
                paceText(for: run)
            }
        }
          .onChange(of: multipleSelection) { newVal in
              runLogViewModel.selectedRun = multipleSelection.first
          }
          .toolbar {
              ToolbarItem(placement: .primaryAction) {
                  Button("Delete", action: {
                      for run in multipleSelection {
                          runLogViewModel.deleteRun(run: run)
                      }
                      runLogViewModel.selectedRun = nil
                      multipleSelection = Set<Run.ID>()
                  })
                  .disabled(multipleSelection.count == 0)
              }
          }
    }
    
    private func dateText(for run: Run) -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: run.date)

        return Text(dateString)
    }
    
    private func distanceText(for run: Run) -> some View {
        Text(String(format: "%.2f", run.distance))
    }
    
    private func durationText(for run: Run) -> some View {
        let hours = Int(run.duration / 3600)
        let minutes = Int((run.duration.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(run.duration.truncatingRemainder(dividingBy: 60))
        
        if hours == 0 {
            return Text(String(format: "%02dm %02ds", minutes, seconds))
        } else {
            return Text(String(format: "%2dh %02dm", hours, minutes))
        }
    }
    
    private func paceText(for run: Run) -> some View {
        let totalSeconds = Int(run.pace)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return Text(String(format: "%02d:%02d /mi", minutes, seconds))
    }
    
}
