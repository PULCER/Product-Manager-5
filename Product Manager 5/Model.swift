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
    var title: String // Added title property
    var content: String
    var timestamp: Date = Date()

    init(title: String, content: String, timestamp: Date = Date()) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }
}


@Model
class Initiative {
    var title: String
    var summary: String = ""
    @Relationship(deleteRule: .cascade) var notes: [Note] = []
    var priority: Priority = Priority(rawValue: "Low") ?? .low
    
    init(title: String) {
        self.title = title
    }
    
    func updateDetails(summary: String, notes: [Note], priority: Priority) {
        self.summary = summary
        self.notes = notes
        self.priority = priority
    }
}
