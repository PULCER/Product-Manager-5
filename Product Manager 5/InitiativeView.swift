import SwiftUI

struct InitiativeView: View {
    let initiative: Initiative

    var body: some View {
        VStack(alignment: .leading) {
            Text(initiative.title).font(.headline)
            
            if !initiative.notes.isEmpty {
                Text("Notes: \(initiative.notes.count)").font(.subheadline)
            }
            
            if !initiative.tasks.isEmpty {
                Text("Tasks: \(initiative.tasks.count)").font(.subheadline)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.4))
        .cornerRadius(8)
    }
}
