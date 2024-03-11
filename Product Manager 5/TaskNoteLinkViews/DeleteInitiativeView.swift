import SwiftUI

struct DeleteConfirmationView: View {
    let initiative: Initiative
    @Binding var isPresented: Bool
    @Binding var selectedInitiative: Initiative?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            Text("Confirm Deletion")
                .font(.title)
                .padding()

            Text("Are you sure you want to delete this initiative?")
                .font(.body)
                .padding()

            HStack {
                Button(action: {
                    deleteInitiative()
                    isPresented = false
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
                    isPresented = false
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
    }

    private func deleteInitiative() {
        modelContext.delete(initiative)
        try? modelContext.save()
        selectedInitiative = nil
    }
}
