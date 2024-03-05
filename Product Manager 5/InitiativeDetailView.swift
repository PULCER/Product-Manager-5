import SwiftUI

struct InitiativeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var initiative: Initiative

    @State private var noteTitle: String = ""
    @State private var noteContent: String = ""
    @State private var showingDeleteConfirmation = false

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
                
                Spacer()
                HStack{
                    
                    Button("Add Note") {
                        addNoteToInitiative()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.blue.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Delete Initiative") {
                        showingDeleteConfirmation = true
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.red.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this initiative?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteInitiative()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func addNoteToInitiative() {
        let newNote = Note(title: noteTitle, content: noteContent)
        initiative.notes.append(newNote)
        try? modelContext.save()
        noteTitle = ""
        noteContent = ""
    }

    private func deleteInitiative() {
        try? modelContext.delete(initiative)
        try? modelContext.save()
    }
}
