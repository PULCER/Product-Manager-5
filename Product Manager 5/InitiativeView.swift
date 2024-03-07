import SwiftUI

struct InitiativeView: View {
    let initiative: Initiative
    
    var body: some View {
        let containsUrgentTask = initiative.tasks?.contains(where: { $0.isUrgent && !$0.isCompleted }) ?? false

        let uncompletedTasksCount = initiative.tasks?.filter { !$0.isCompleted }.count ?? 0
        
        VStack(alignment: .leading) {
            Text(initiative.title).font(.headline)
            
            HStack{
                if let notes = initiative.notes, !notes.isEmpty {
                    Text("Notes: \(notes.count)").font(.subheadline)
                }
                
                Text("Tasks: \(uncompletedTasksCount)").font(.subheadline)
            }
        }
        .padding()
        .background(containsUrgentTask ? Color.red.opacity(0.8) : Color.blue.opacity(0.4))
        .cornerRadius(8)
    }
}
