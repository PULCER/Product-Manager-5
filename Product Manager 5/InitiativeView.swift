import SwiftUI

struct InitiativeView: View {
    let initiative: Initiative
    
    var body: some View {
        let containsUrgentTask = initiative.tasks?.contains(where: { $0.isUrgent && !$0.isCompleted }) ?? false
        
        VStack(alignment: .leading) {
            Text(initiative.title).font(.title2)
            
            HStack{
                
                if let tasks = initiative.tasks, !tasks.isEmpty {
                    Text("Tasks: \(tasks.count)").font(.headline)
                } else if let tasks = initiative.tasks, tasks.isEmpty {
                    Text("Tasks: \(tasks.count)").font(.headline).opacity(0)
                }
                
                if let notes = initiative.notes, !notes.isEmpty {
                    Text("Notes: \(notes.count)").font(.headline)
                } else  if let notes = initiative.notes, notes.isEmpty {
                    Text("Notes: \(notes.count)").font(.headline).opacity(0)
                }
            }
        }
        .padding(8)
        .background(containsUrgentTask ? Color.red.opacity(0.8) : Color.blue.opacity(0.4))
        .cornerRadius(8)
    }
}
