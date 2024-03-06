import SwiftUI

struct InitiativeView: View {
    let initiative: Initiative
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(initiative.title).font(.headline)
            
            if let notes = initiative.notes, !notes.isEmpty {
                Text("Notes: \(notes.count)").font(.subheadline)
            }
            
            if let tasks = initiative.tasks, !tasks.isEmpty {
                Text("Tasks: \(tasks.count)").font(.subheadline)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.4))
        .cornerRadius(8)
    }
}
