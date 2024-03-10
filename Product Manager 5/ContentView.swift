import SwiftUI
import SwiftData
import AppKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var initiatives: [Initiative]
    
    @State private var title: String = ""
    @State private var priority: Priority = .low
    @State private var selectedInitiative: Initiative? = nil
    @State private var showCompleted: Bool = false
    @State private var showingTextualRepresentation = false
    @State private var textualRepresentation = ""
    
    var body: some View {
        
        let lowPriorityInitiatives = initiatives.filter { $0.priority == .low && ($0.isCompleted == showCompleted) }
        let mediumPriorityInitiatives = initiatives.filter { $0.priority == .medium && ($0.isCompleted == showCompleted) }
        let highPriorityInitiatives = initiatives.filter { $0.priority == .high && ($0.isCompleted == showCompleted) }
        let highestPriorityInitiatives = initiatives.filter { $0.priority == .highest && ($0.isCompleted == showCompleted) }
        
        VStack {
            
            if let selectedInitiative = selectedInitiative {
                InitiativeDetailView(initiative: selectedInitiative, selectedInitiative: $selectedInitiative)
            }
            
            else {
                VStack {
                    GeometryReader { geometry in
                        VStack {
                            HStack {
                                Text("Highest")
                                    .font(.title)
                                Spacer()
                                
                        
                        

                                
                                Toggle(isOn: $showCompleted) {
                                    Text(showCompleted ? "Complete" : "Incomplete")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(highestPriorityInitiatives) { initiative in
                                        Button(action: {
                                            self.selectedInitiative = initiative
                                        }) {
                                            InitiativeView(initiative: initiative)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            Divider().padding()
                            
                            HStack {
                                Text("High")
                                    .font(.title)
                                Spacer()
                            }
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(highPriorityInitiatives) { initiative in
                                        Button(action: {
                                            self.selectedInitiative = initiative
                                        }) {
                                            InitiativeView(initiative: initiative)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            Divider().padding()
                            
                            HStack {
                                Text("Medium")
                                    .font(.title)
                                Spacer()
                            }
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(mediumPriorityInitiatives) { initiative in
                                        Button(action: {
                                            self.selectedInitiative = initiative
                                        }) {
                                            InitiativeView(initiative: initiative)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            Divider().padding()
                            
                            HStack {
                                Text("Low")
                                    .font(.title)
                                Spacer()
                            }
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(lowPriorityInitiatives) { initiative in
                                        Button(action: {
                                            self.selectedInitiative = initiative
                                        }) {
                                            InitiativeView(initiative: initiative)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    TextField("Title", text: $title)
                    
                    HStack {
                        Picker("Priority", selection: $priority) {
                            Text("Low").tag(Priority.low)
                            Text("Medium").tag(Priority.medium)
                            Text("High").tag(Priority.high)
                            Text("Highest").tag(Priority.highest)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .font(.headline)
                        
                        Button("Textual Representation") {
                            self.textualRepresentation = initiatives.reduce("") { (result, initiative) -> String in
                                result + generateTextualRepresentation(for: initiative) + "\n\n"
                            }
                            self.showingTextualRepresentation = true
                        }
                        .padding(5)
                        .background(Color.blue.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Button(action: {
                        addInitiative()
                    }) {
                        Text("Add Initiative")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        } .sheet(isPresented: $showingTextualRepresentation) {
            TextualRepresentationView(text: $textualRepresentation)
        }
    }
    
    private func generateTextualRepresentation(for initiative: Initiative) -> String {
            var text = "Title: \(initiative.title)\n"
            text += "Summary: \(initiative.summary)\n"
            text += "Priority: \(initiative.priority.rawValue)\n"
            text += "Status: \(initiative.isCompleted ? "Completed" : "Incomplete")\n"
            
            if let tasks = initiative.tasks {
                text += "Tasks:\n" + tasks.map { "\t- \($0.title): \($0.content) [\( $0.isUrgent ? "Urgent" : "")][\($0.isCompleted ? "Completed" : "Incomplete")]" }.joined(separator: "\n")
            }
            
            if let notes = initiative.notes {
                text += "\nNotes:\n" + notes.map { "\t- \($0.title): \($0.content)" }.joined(separator: "\n")
            }
            
            if let links = initiative.links {
                text += "\nLinks:\n" + links.map { "\t- \($0.title): \($0.url.absoluteString)" }.joined(separator: "\n")
            }
            
            return text
        }
    
    private func addInitiative() {
        let newInitiative = Initiative(title: title)
        newInitiative.priority = priority
        title = ""
        modelContext.insert(newInitiative)
        try? modelContext.save()
    }
}



