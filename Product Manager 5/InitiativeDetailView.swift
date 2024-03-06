import SwiftUI

struct InitiativeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var initiative: Initiative
    @Binding var selectedInitiative: Initiative?
    @State private var showingDeleteConfirmation = false
    @State private var editedTitle: String
    @State private var editedSummary: String
    @State private var selectedPriority: Priority
    @State private var showingAddTaskModal = false
    @State private var showingAddNoteModal = false
    
    init(initiative: Initiative, selectedInitiative: Binding<Initiative?>) {
        self.initiative = initiative
        self._selectedInitiative = selectedInitiative
        _editedTitle = State(initialValue: initiative.title)
        _editedSummary = State(initialValue: initiative.summary)
        _selectedPriority = State(initialValue: initiative.priority)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("Title", text: $editedTitle)
                    .font(.headline)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $editedSummary)
                    .frame(minHeight: CGFloat(5 * 20))
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                    .padding(.bottom)
                
                Picker("Priority", selection: $selectedPriority) {
                    Text("Low").tag(Priority.low)
                    Text("Medium").tag(Priority.medium)
                    Text("High").tag(Priority.high)
                    Text("Highest").tag(Priority.highest)
                                }
                                .pickerStyle(MenuPickerStyle())
                
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
                
                Text("Tasks:").font(.headline)
                ForEach(initiative.tasks) { task in
                    VStack(alignment: .leading) {
                        Text(task.title).font(.headline)
                        Text(task.content).font(.subheadline)
                        Text("Timestamp: \(task.timestamp, formatter: itemFormatter)").font(.footnote)
                        Text("Urgent: \(task.isUrgent ? "Yes" : "No")").font(.footnote)
                    }
                    .padding()
                }
                
                Spacer()
                HStack{
                    
                    Button("Add Task") {
                        showingAddTaskModal = true
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.blue.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .sheet(isPresented: $showingAddTaskModal) {
                        AddTaskView(initiative: initiative)
                    }
                    
                    Button("Add Note") {
                        showingAddNoteModal = true
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.blue.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .sheet(isPresented: $showingAddNoteModal) {
                        AddNoteView(initiative: initiative)
                    }
                    
                    Button("Delete Initiative") {
                        showingDeleteConfirmation = true
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.red.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Go Back") {
                        updateInitiativeDetails()
                        try? modelContext.save()
                        self.selectedInitiative = nil
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.teal.opacity(0.4))
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
    
    private func updateInitiativeDetails() {
        initiative.title = editedTitle
        initiative.summary = editedSummary
    }

    private func deleteInitiative() {
        modelContext.delete(initiative)
        try? modelContext.save()
        self.selectedInitiative = nil
    }
}

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle = ""
    @State private var taskContent = ""
    @State private var isUrgent = false
    var initiative: Initiative
    
    var body: some View {
        VStack {
            TextField("Title", text: $taskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $taskContent)
                .frame(minHeight: 100)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            Toggle("Is Urgent", isOn: $isUrgent)
            
            Button("Add Task") {
                let newTask = Task(title: taskTitle, content: taskContent, isUrgent: isUrgent)
                initiative.tasks.append(newTask)
                try? modelContext.save()
                dismiss()
            }
            .padding()
            .background(Color.blue.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var noteTitle = ""
    @State private var noteContent = ""
    var initiative: Initiative
    
    var body: some View {
        VStack {
            TextField("Title", text: $noteTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $noteContent)
                .frame(minHeight: 100)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            Button("Add Note") {
                let newNote = Note(title: noteTitle, content: noteContent)
                initiative.notes.append(newNote)
                try? modelContext.save()
                dismiss()
            }
            .padding()
            .background(Color.blue.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
