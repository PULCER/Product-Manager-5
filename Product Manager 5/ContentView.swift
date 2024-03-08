import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var initiatives: [Initiative]
    
    @State private var title: String = ""
    @State private var priority: Priority = .low
    @State private var selectedInitiative: Initiative? = nil
    @State private var showCompleted: Bool = false
    
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
        }
    }
    
    private func addInitiative() {
        let newInitiative = Initiative(title: title)
        newInitiative.priority = priority
        title = ""
        modelContext.insert(newInitiative)
        try? modelContext.save()
    }
}
