import Foundation
import SwiftData

enum Priority: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case highest = "Highest"
}

@Model
final class Note {
    var title: String
    var content: String
    var timestamp: Date = Date()
    var isCompleted: Bool = false

    init(title: String, content: String, timestamp: Date = Date(), isCompleted: Bool = false) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.isCompleted = isCompleted
    }
}

@Model
final class Task {
    var title: String
    var content: String
    var timestamp: Date = Date()
    var isUrgent: Bool = false
    var isCompleted: Bool = false

    init(title: String, content: String, timestamp: Date = Date(), isUrgent: Bool = false, isCompleted: Bool = false) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.isUrgent = isUrgent
        self.isCompleted = isCompleted
    }
}


@Model
final class Initiative {
    var title: String
    var summary: String = ""
    @Relationship(deleteRule: .cascade) var notes: [Note] = []
    @Relationship(deleteRule: .cascade) var tasks: [Task] = []
    var priority: Priority = Priority(rawValue: "Low") ?? .low
    var isCompleted: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    func updateDetails(summary: String, notes: [Note], tasks: [Task], priority: Priority, isCompleted: Bool = false) {
        self.summary = summary
        self.notes = notes
        self.tasks = tasks
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
