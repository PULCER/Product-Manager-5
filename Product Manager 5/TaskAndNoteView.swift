import SwiftUI
import SwiftData

struct TaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle = ""
    @State private var taskContent = ""
    @State private var isUrgent = false
    var initiative: Initiative
    var task: InitiativeTask?
    
    init(initiative: Initiative, task: InitiativeTask? = nil) {
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
                    Button(action: {
                        if let task = task, var tasks = initiative.tasks {
                            tasks.removeAll { $0 == task }
                            initiative.tasks = tasks
                            try? modelContext.save()
                        }
                        dismiss()
                    }) {
                        Text("Delete Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        let newTask = InitiativeTask(title: taskTitle, content: taskContent, isUrgent: isUrgent)
                        initiative.tasks?.append(newTask)
                        try? modelContext.save()
                        dismiss()
                    }) {
                        Text("Add Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                Button(action: {
                    if let task = task {
                        task.title = taskTitle
                        task.content = taskContent
                        task.isUrgent = isUrgent
                        try? modelContext.save()
                    }
                    dismiss()
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
        .padding()
    }
}

struct NoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var noteTitle = ""
    @State private var noteContent = ""
    var initiative: Initiative
    var note: InitiativeNote?
    
    init(initiative: Initiative, note: InitiativeNote? = nil) {
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
                    Button(action: {
                        if let note = note, var notes = initiative.notes {
                            notes.removeAll { $0 == note }
                            initiative.notes = notes
                            try? modelContext.save()
                        }
                        dismiss()
                    }) {
                        Text("Delete Note")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        let newNote = InitiativeNote(title: noteTitle, content: noteContent)
                        initiative.notes?.append(newNote)
                        try? modelContext.save()
                        dismiss()
                    }) {
                        Text("Add Note")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                Button(action: {
                    if let note = note {
                        note.title = noteTitle
                        note.content = noteContent
                        try? modelContext.save()
                    }
                    dismiss()
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
        .padding()
    }
}
