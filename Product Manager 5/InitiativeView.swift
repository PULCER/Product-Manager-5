import SwiftUI
import SwiftData

struct InitiativeView: View {
    let initiative: Initiative
    var body: some View {
        VStack(alignment: .leading) {
            Text(initiative.title).font(.headline)
            Text(initiative.summary).font(.subheadline)
 //           Text("Priority: \(initiative.priority.rawValue)").font(.subheadline)
            if !initiative.notes.isEmpty {
                Text("Notes:").font(.headline)
                ForEach(initiative.notes) { note in
                    Text(note.content).font(.subheadline)
//                    Text("Timestamp: \(note.timestamp, formatter: itemFormatter)").font(.footnote)
                }
            }
        }
    }
}

