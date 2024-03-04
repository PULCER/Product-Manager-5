import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var initiatives: [Initiative]
    
    @State private var title: String = ""
    @State private var summary: String = ""
    @State private var priority: Priority = .low
    @State private var notes: [Note] = []
    @State private var selectedInitiative: Initiative? = nil
    
    var body: some View {
        VStack {
            if let selectedInitiative = selectedInitiative {
                InitiativeDetailView(initiative: selectedInitiative)
                    .onTapGesture {
                        self.selectedInitiative = nil
                    }
            } else {
                List {
                    
                    Section(header: Text("Existing Initiatives")) {
                        ForEach(initiatives) { initiative in
                            Button(action: {
                                self.selectedInitiative = initiative
                            }) {
                                VStack(alignment: .leading) {
                                    Text(initiative.title).font(.headline)
                                    Text(initiative.summary).font(.subheadline)
                                    Text("Priority: \(initiative.priority.rawValue)").font(.subheadline)
                                    if !initiative.notes.isEmpty {
                                        Text("Notes:").font(.headline)
                                        ForEach(initiative.notes) { note in
                                            Text(note.content).font(.subheadline)
                                            Text("Timestamp: \(note.timestamp, formatter: itemFormatter)").font(.footnote)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Add New Initiative")) {
                        TextField("Title", text: $title)
                        TextField("Summary", text: $summary)
                        Picker("Priority", selection: $priority) {
                            Text("Low").tag(Priority.low)
                            Text("Medium").tag(Priority.medium)
                            Text("High").tag(Priority.high)
                            Text("Highest").tag(Priority.highest)
                        }
                        Button("Add Initiative") {
                            addInitiative()
                        }
                    }
                }
            }
        }
    }
    
    private func addInitiative() {
        let newInitiative = Initiative(title: title)
        newInitiative.updateDetails(summary: summary, notes: notes, priority: priority)
        modelContext.insert(newInitiative)
        title = ""
        summary = ""
        notes = []
        selectedInitiative = nil
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
