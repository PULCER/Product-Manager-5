import SwiftUI
import Foundation

struct InitiativeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    var initiative: Initiative
    @Binding var selectedInitiative: Initiative?
    @State private var showingDeleteConfirmation = false
    @State private var editedTitle: String
    @State private var editedSummary: String
    @State private var selectedPriority: Priority
    @State private var isCompleted: Bool
    @State private var showingAddTaskModal = false
    @State private var showingAddNoteModal = false
    @State private var selectedNote: InitiativeNote?
    @State private var selectedTask: InitiativeTask?
    @State private var showingAddLinkModal = false
    @State private var selectedLink: InitiativeLink?
    
    init(initiative: Initiative, selectedInitiative: Binding<Initiative?>) {
        self.initiative = initiative
        self._selectedInitiative = selectedInitiative
        _editedTitle = State(initialValue: initiative.title)
        _editedSummary = State(initialValue: initiative.summary)
        _selectedPriority = State(initialValue: initiative.priority)
        _isCompleted = State(initialValue: initiative.isCompleted)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Title", text: $editedTitle)
                    .font(.headline)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Toggle(isOn: $isCompleted) {
                    Text(isCompleted ? "Complete" : "Incomplete")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            TextEditor(text: $editedSummary)
                .frame(minHeight: CGFloat(5 * 20))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                .padding(.bottom)
            
            
            if let tasks = initiative.tasks, !tasks.isEmpty {
                Text("Tasks:").font(.headline)
                HStack {
                    ForEach(tasks) { task in
                        Button(action: {
                            selectedTask = task
                        }) {
                            VStack {
                                Text(task.title)
                                    .lineLimit(2)
                            }
                            .padding(10)
                            .background(task.isCompleted ? Color.gray : (task.isUrgent ? Color.red.opacity(0.4) : Color.blue.opacity(0.4)))
                            .font(.title2)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            if let notes = initiative.notes, !notes.isEmpty {
                Text("Notes:").font(.headline)
                HStack {
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
                            .font(.title2)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            if let links = initiative.links, !links.isEmpty {
                Text("Links:").font(.headline)
                HStack {
                    ForEach(links) { link in
                        Button(action: {
                            selectedLink = link
                        }) {
                            VStack {
                                Text(link.title)
                                    .lineLimit(2)
                            }
                            .padding(10)
                            .font(.title2)
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Link(destination: link.url) {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Spacer()
            
            Picker("Priority", selection: $selectedPriority) {
                Text("Low").tag(Priority.low)
                Text("Medium").tag(Priority.medium)
                Text("High").tag(Priority.high)
                Text("Highest").tag(Priority.highest)
            }
            .pickerStyle(SegmentedPickerStyle())
                        
            HStack {
                Button(action: {
                    showingAddTaskModal = true
                }) {
                    Text("Add Task")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.title2)
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
                        .font(.title2)
                        .background(Color.blue.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    showingAddLinkModal = true
                }) {
                    Text("Add Link")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.title2)
                        .background(Color.blue.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.title2)
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
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.title2)
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
        .sheet(isPresented: $showingAddLinkModal) {
            LinkView(initiative: initiative)
        }
        .sheet(item: $selectedLink) { link in
            LinkView(initiative: initiative, link: link)
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
        initiative.isCompleted = isCompleted
    }
    
    private func deleteInitiative() {
        modelContext.delete(initiative)
        try? modelContext.save()
        self.selectedInitiative = nil
    }
}

