import SwiftUI

struct InitiativeView: View {
    let initiative: Initiative
    
    var body: some View {
        
        let containsUrgentTask = initiative.tasks?.contains { $0.isUrgent } ?? false
        
        VStack(alignment: .leading) {
            Text(initiative.title).font(.headline)
            
            HStack{
                
                if let notes = initiative.notes, !notes.isEmpty {
                    Text("Notes: \(notes.count)").font(.subheadline)
                }
                
                if let tasks = initiative.tasks, !tasks.isEmpty {
                    Text("Tasks: \(tasks.count)").font(.subheadline)
                }
            }
        }
        .padding()
        .background(containsUrgentTask ? Color.red.opacity(0.8) : Color.blue.opacity(0.4))
        .cornerRadius(8)
    }
}
