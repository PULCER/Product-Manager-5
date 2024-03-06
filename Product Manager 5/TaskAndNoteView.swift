import SwiftUI
import SwiftData

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
                .frame(minHeight: 300)
                .frame(minWidth: 300)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            Toggle("Is Urgent", isOn: $isUrgent)
            
            HStack{
                Button("Add Task") {
                    let newTask = Task(title: taskTitle, content: taskContent, isUrgent: isUrgent)
                    initiative.tasks.append(newTask)
                    try? modelContext.save()
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.blue.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(minWidth: 50)
                
                Spacer()
                
                Button("Go Back") {
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
                .frame(minHeight: 300)
                .frame(minWidth: 300)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            
            HStack{
                Button("Add Note") {
                    let newNote = Note(title: noteTitle, content: noteContent)
                    initiative.notes.append(newNote)
                    try? modelContext.save()
                    dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.blue.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(minWidth: 50)
                
                Spacer()
                
                Button("Go Back") {
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
