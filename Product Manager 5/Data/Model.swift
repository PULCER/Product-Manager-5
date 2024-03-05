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
class Initiative {
    var title: String
    var summary: String = ""
    @Relationship(deleteRule: .cascade) var notes: [Note] = []
    var priority: Priority = Priority(rawValue: "Low") ?? .low
    var isCompleted: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    func updateDetails(summary: String, notes: [Note], priority: Priority) {
        self.summary = summary
        self.notes = notes
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
