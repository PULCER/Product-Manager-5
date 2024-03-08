import SwiftUI
import SwiftData

struct TaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle = ""
    @State private var taskContent = ""
    @State private var isUrgent = false
    @State private var isCompleted = false
    var initiative: Initiative
    var task: InitiativeTask?
    
    init(initiative: Initiative, task: InitiativeTask? = nil) {
        self.initiative = initiative
        self.task = task
        if let task = task {
            _taskTitle = State(initialValue: task.title)
            _taskContent = State(initialValue: task.content)
            _isUrgent = State(initialValue: task.isUrgent)
            _isCompleted = State(initialValue: task.isCompleted)
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
                Toggle("Urgent", isOn: $isUrgent)
                Toggle("Complete", isOn: $isCompleted)
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
                        Text("Delete")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        if let task = task {
                            task.title = taskTitle
                            task.content = taskContent
                            task.isUrgent = isUrgent
                            task.isCompleted = isCompleted
                            try? modelContext.save()
                        }
                        dismiss()
                    }) {
                        Text("Back")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        let newTask = InitiativeTask(title: taskTitle, content: taskContent, isUrgent: isUrgent, isCompleted: isCompleted)
                        initiative.tasks?.append(newTask)
                        try? modelContext.save()
                        dismiss()
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Discard")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
    }
}
