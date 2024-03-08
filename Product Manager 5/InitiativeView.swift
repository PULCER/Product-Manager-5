import SwiftUI

struct InitiativeView: View {

    let initiative: Initiative

    var body: some View {
        let containsUrgentTask = initiative.tasks?.contains(where: { $0.isUrgent && !$0.isCompleted }) ?? false
        let uncompletedTasksCount = initiative.tasks?.filter { !$0.isCompleted }.count ?? 0

        VStack(alignment: .leading) {
            Text(initiative.title).font(.title2)

            HStack {
                if let notes = initiative.notes, !notes.isEmpty {
                    Text("Notes: \(notes.count)").font(.headline)
                }

                Text("Tasks: \(uncompletedTasksCount)").font(.headline)
            }
        }
        .padding(8)
        .background(
            LinearGradient(gradient: Gradient(colors: [containsUrgentTask ? Color.pink : Color.blue, containsUrgentTask ? Color.red : Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.6)
        )
        .cornerRadius(8)
    }
}
