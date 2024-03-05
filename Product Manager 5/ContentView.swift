import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var initiatives: [Initiative]
    
    @State private var title: String = ""
    @State private var summary: String = ""
    @State private var priority: Priority = .low
    @State private var notes: [Note] = []
    @State private var tasks: [Task] = []
    @State private var selectedInitiative: Initiative? = nil
    
    var body: some View {
        let lowPriorityInitiatives = initiatives.filter { $0.priority == .low && !$0.isCompleted }
        let mediumPriorityInitiatives = initiatives.filter { $0.priority == .medium && !$0.isCompleted }
        let highPriorityInitiatives = initiatives.filter { $0.priority == .high && !$0.isCompleted }
        let highestPriorityInitiatives = initiatives.filter { $0.priority == .highest && !$0.isCompleted }
        VStack {
            if let selectedInitiative = selectedInitiative {
                InitiativeDetailView(initiative: selectedInitiative)
                    .onTapGesture {
                        self.selectedInitiative = nil
                    }
            } else {
                VStack{
                    Text("Highest")
                        .font(.title)
                    ForEach(highestPriorityInitiatives) { initiative in
                        Button(action: {
                            self.selectedInitiative = initiative
                        }) {
                            InitiativeView(initiative: initiative)
                        }.buttonStyle(PlainButtonStyle())
                    }.padding()
                    Divider().padding()
                    
                    VStack{
                        GeometryReader { geometry in
                            HStack{
                                
                                VStack {
                                    Text("High")
                                        .font(.title)
                                    ForEach(highPriorityInitiatives) { initiative in
                                        Button(action: {
                                            self.selectedInitiative = initiative
                                        }) {
                                            InitiativeView(initiative: initiative)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    Spacer()
                                }.frame(width: geometry.size.width / 3, alignment: .leading)
                                
                                Divider()
                                
                                VStack {
                                    Text("Medium")
                                        .font(.title)
                                    ForEach(mediumPriorityInitiatives) { initiative in
                                        Button(action: {
                                            self.selectedInitiative = initiative
                                        }) {
                                            InitiativeView(initiative: initiative)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    Spacer()
                                }.frame(width: geometry.size.width / 3, alignment: .leading)
                                
                                Divider()
                                
                                VStack {
                                    Text("Low")
                                        .font(.title)
                                    ForEach(lowPriorityInitiatives) { initiative in
                                        Button(action: {
                                            self.selectedInitiative = initiative
                                        }) {
                                            InitiativeView(initiative: initiative)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    Spacer()
                                    
                                }.frame(width: geometry.size.width / 3, alignment: .leading)
                            }
                        }
                    }
                }
                
                
                Spacer()
                
                VStack {
                    TextField("Title", text: $title)
                    TextField("Summary", text: $summary)
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(Priority.low)
                        Text("Medium").tag(Priority.medium)
                        Text("High").tag(Priority.high)
                        Text("Highest").tag(Priority.highest)
                    }.pickerStyle(SegmentedPickerStyle())
                    
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
        newInitiative.updateDetails(summary: summary, notes: notes, tasks: tasks,  priority: priority)
        modelContext.insert(newInitiative)
        title = ""
        summary = ""
        notes = []
        selectedInitiative = nil
    }
}


