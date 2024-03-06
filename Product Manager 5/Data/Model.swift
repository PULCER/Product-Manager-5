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
    
    func updateDetails(summary: String? = nil, notes: [Note]? = nil, tasks: [Task]? = nil, priority: Priority? = nil, isCompleted: Bool? = nil) {
        if let summary = summary {
            self.summary = summary
        }
        if let notes = notes {
            self.notes = notes
        }
        if let tasks = tasks {
            self.tasks = tasks
        }
        if let priority = priority {
            self.priority = priority
        }
        if let isCompleted = isCompleted {
            self.isCompleted = isCompleted
        }
    }

}
