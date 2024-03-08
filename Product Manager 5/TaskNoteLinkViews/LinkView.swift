import SwiftUI

struct LinkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var linkTitle = ""
    @State private var linkURL = ""
    var initiative: Initiative
    var link: InitiativeLink?
    
    init(initiative: Initiative, link: InitiativeLink? = nil) {
        self.initiative = initiative
        self.link = link
        if let link = link {
            _linkTitle = State(initialValue: link.title)
            _linkURL = State(initialValue: link.url.absoluteString)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Title", text: $linkTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("URL", text: $linkURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                if link != nil {
                    Button(action: {
                        if let link = link, var links = initiative.links {
                            links.removeAll { $0 == link }
                            initiative.links = links
                            try? modelContext.save()
                        }
                        dismiss()
                    }) {
                        Text("Delete Link")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        if let url = URL(string: linkURL) {
                            let newLink = InitiativeLink(title: linkTitle, url: url)
                            initiative.links?.append(newLink)
                            try? modelContext.save()
                        }
                        dismiss()
                    }) {
                        Text("Add Link")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                Button(action: {
                    if let link = link, let url = URL(string: linkURL) {
                        link.title = linkTitle
                        link.url = url
                        try? modelContext.save()
                    }
                    dismiss()
                }) {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .frame(width: 300)
    }
}
