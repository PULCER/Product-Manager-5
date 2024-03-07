import SwiftUI

struct InitiativeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var initiative: Initiative
    @Binding var selectedInitiative: Initiative?
    @State private var showingDeleteConfirmation = false
    @State private var editedTitle: String
    @State private var editedSummary: String
    @State private var selectedPriority: Priority
    @State private var selectedStatus: Bool
    @State private var showingAddTaskModal = false
    @State private var showingAddNoteModal = false
    @State private var selectedNote: InitiativeNote?
    @State private var selectedTask: InitiativeTask?
    
    init(initiative: Initiative, selectedInitiative: Binding<Initiative?>) {
        self.initiative = initiative
        self._selectedInitiative = selectedInitiative
        _editedTitle = State(initialValue: initiative.title)
        _editedSummary = State(initialValue: initiative.summary)
        _selectedPriority = State(initialValue: initiative.priority)
        _selectedStatus = State(initialValue: initiative.isCompleted)
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
                .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                
                Picker("Status", selection: $selectedStatus) {
                    Text("Incomplete").tag(false)
                    Text("Complete").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Notes:").font(.headline)
                HStack {
                    if let notes = initiative.notes {
                        ForEach(notes) { note in
                            Button(action: {
                                selectedNote = note
                            }) {
                                VStack {
                                    Text(note.title)
                                        .lineLimit(2)
                                }
                                .padding(10)
                                .background(Color.blue.opacity(0.4))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Text("Tasks:").font(.headline)
                ScrollView {
                    HStack {
                        if let tasks = initiative.tasks {
                            ForEach(tasks) { task in
                                Button(action: {
                                    selectedTask = task
                                }) {
                                    VStack {
                                        Text(task.title)
                                            .lineLimit(2)
                                    }
                                    // Change background color based on completion status
                                    .padding(10)
                                    .background(task.isCompleted ? Color.gray : (task.isUrgent ? Color.red.opacity(0.4) : Color.blue.opacity(0.4)))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                
                Spacer()
                
                Divider()
                
                HStack {
                    Button(action: {
                        showingAddTaskModal = true
                    }) {
                        Text("Add Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        showingAddNoteModal = true
                    }) {
                        Text("Add Note")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Text("Delete Initiative")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        updateInitiativeDetails()
                        try? modelContext.save()
                        self.selectedInitiative = nil
                    }) {
                        Text("Go Back")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
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
        initiative.priority = selectedPriority 
        initiative.isCompleted = selectedStatus
    }
    
    private func deleteInitiative() {
        modelContext.delete(initiative)
        try? modelContext.save()
        self.selectedInitiative = nil
    }
}

