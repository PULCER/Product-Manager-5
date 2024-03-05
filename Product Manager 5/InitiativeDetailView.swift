import SwiftUI

struct InitiativeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var initiative: Initiative

    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(initiative.title).font(.headline)
                Text(initiative.summary).font(.subheadline)
                Text("Priority: \(initiative.priority.rawValue)").font(.subheadline)
                Divider()
                Text("Add Note:").font(.headline)
                TextField("Note Title", text: $noteTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Note Content", text: $noteContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add Note") {
                    addNoteToInitiative()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Divider()
                Text("Notes:").font(.headline)
                ForEach(initiative.notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title).font(.headline)
                        Text(note.content).font(.subheadline)
                        Text("Timestamp: \(note.timestamp, formatter: itemFormatter)").font(.footnote)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }

    private func addNoteToInitiative() {
        let newNote = Note(title: noteTitle, content: noteContent)
        initiative.notes.append(newNote)
        try? modelContext.save()
        noteTitle = ""
        noteContent = ""
    }
}

