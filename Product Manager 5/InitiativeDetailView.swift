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
    @State private var selectedNote: Note?
    @State private var selectedTask: Task?
    
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
                             LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                                 ForEach(initiative.notes) { note in
                                     Button(action: {
                                         selectedNote = note
                                     }) {
                                         VStack {
                                             Text(note.title)
                                                 .font(.headline)
                                                 .lineLimit(1)
                                         }
                                         .padding()
                                         .background(Color.blue.opacity(0.4))
                                         .foregroundColor(.white)
                                         .cornerRadius(10)
                                     }
                                     .buttonStyle(PlainButtonStyle())
                                 }
                             }
                             
                             Text("Tasks:").font(.headline)
                             LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 10) {
                                 ForEach(initiative.tasks) { task in
                                     Button(action: {
                                         selectedTask = task
                                     }) {
                                         VStack {
                                             Text(task.title)
                                                 .font(.headline)
                                                 .lineLimit(1)
                                         }
                                         .padding()
                                         .background(task.isUrgent ? Color.red.opacity(0.4) : Color.blue.opacity(0.4))
                                         .foregroundColor(.white)
                                         .cornerRadius(10)
                                     }
                                     .buttonStyle(PlainButtonStyle())
                                 }
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
                        TaskView(initiative: initiative)
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
                        NoteView(initiative: initiative)
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
            .sheet(isPresented: $showingAddTaskModal) {
                           TaskView(initiative: initiative)
                       }
 
                       
                       .sheet(item: $selectedTask) { task in
                           TaskView(initiative: initiative, task: task)
                       }
                       .sheet(isPresented: $showingAddNoteModal) {
                                       NoteView(initiative: initiative)
                                   }
                                   
                                   
                                   .sheet(item: $selectedNote) { note in
                                       NoteView(initiative: initiative, note: note)
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

