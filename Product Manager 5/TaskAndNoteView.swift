import SwiftUI
import SwiftData

struct TaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle = ""
    @State private var taskContent = ""
    @State private var isUrgent = false
    var initiative: Initiative
    var task: Task?
    
    init(initiative: Initiative, task: Task? = nil) {
        self.initiative = initiative
        self.task = task
        if let task = task {
            _taskTitle = State(initialValue: task.title)
            _taskContent = State(initialValue: task.content)
            _isUrgent = State(initialValue: task.isUrgent)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Title", text: $taskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $taskContent)
                .frame(minHeight: 300)
                .frame(minWidth: 300)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            HStack{
                Toggle("Is Urgent", isOn: $isUrgent)
                Spacer()
            }
            
            HStack{
                if task != nil {
                    Button("Delete Task") {
                                            if let task = task, var tasks = initiative.tasks {
                                                tasks.removeAll { $0 == task }
                                                initiative.tasks = tasks
                                                try? modelContext.save()
                                            }
                        dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.red.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(minWidth: 50)
                } else {
                    Button("Add Task") {
                                           let newTask = Task(title: taskTitle, content: taskContent, isUrgent: isUrgent)
                                           initiative.tasks?.append(newTask)
                                           try? modelContext.save()
                        dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.blue.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(minWidth: 50)
                }
                
                Spacer()
                
                Button("Go Back") {
                    if let task = task {
                        task.title = taskTitle
                        task.content = taskContent
                        task.isUrgent = isUrgent
                        try? modelContext.save()
                    }
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.blue.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(minWidth: 50)
            }
        }
        .padding()
    }
}

struct NoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var noteTitle = ""
    @State private var noteContent = ""
    var initiative: Initiative
    var note: Note?
    
    init(initiative: Initiative, note: Note? = nil) {
        self.initiative = initiative
        self.note = note
        if let note = note {
            _noteTitle = State(initialValue: note.title)
            _noteContent = State(initialValue: note.content)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Title", text: $noteTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $noteContent)
                .frame(minHeight: 300)
                .frame(minWidth: 300)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            HStack {
                if note != nil {
                    Button("Delete Note") {
                        if let note = note, var notes = initiative.notes {
                                                   notes.removeAll { $0 == note }
                                                   initiative.notes = notes
                                                   try? modelContext.save()
                                               }
                        dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.red.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(minWidth: 50)
                } else {
                    Button("Add Note") {
                        let newNote = Note(title: noteTitle, content: noteContent)
                                              initiative.notes?.append(newNote)
                                              try? modelContext.save()
                        dismiss()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.blue.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(minWidth: 50)
                }
                
                Spacer()
                
                Button("Go Back") {
                    if let note = note {
                        note.title = noteTitle
                        note.content = noteContent
                        try? modelContext.save()
                    }
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.blue.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(minWidth: 50)
            }
        }
        .padding()
    }
}
