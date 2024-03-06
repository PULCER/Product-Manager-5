import SwiftUI

struct InitiativeView: View {
    let initiative: Initiative

    var body: some View {
        VStack(alignment: .leading) {
            Text(initiative.title).font(.headline)
            if !initiative.notes.isEmpty {
                Text("Notes:").font(.headline)
                ForEach(initiative.notes) { note in
                    Text(note.content).font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.4))
        .cornerRadius(8)
    }
}
