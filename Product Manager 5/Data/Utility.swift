import Foundation

public let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


extension Initiative {
    func textualRepresentation() -> String {
        var text = "Title: \(self.title)\n"
        text += "Summary: \(self.summary)\n"
        text += "Priority: \(self.priority.rawValue)\n"
        text += "Status: \(self.isCompleted ? "Completed" : "Incomplete")\n"
        
        if let tasks = self.tasks {
            text += "Tasks:\n" + tasks.map { "\t- \($0.title): \($0.content) [\( $0.isUrgent ? "Urgent" : "")][\($0.isCompleted ? "Completed" : "Incomplete")]" }.joined(separator: "\n")
        }
        
        if let notes = self.notes {
            text += "\nNotes:\n" + notes.map { "\t- \($0.title): \($0.content)" }.joined(separator: "\n")
        }
        
        if let links = self.links {
            text += "\nLinks:\n" + links.map { "\t- \($0.title): \($0.url.absoluteString)" }.joined(separator: "\n")
        }
        
        return text
    }
}
