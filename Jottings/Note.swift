//
//  Note.swift
//  Jottings
//
//  Created by Russell Blickhan on 6/22/24.
//

import Foundation
import SwiftData

@Model
final class Note {
    var id: UUID
    var content: String
    var timestamp: Date
    var isArchived: Bool

    init(content: String, timestamp: Date) {
        id = UUID()
        self.content = content
        self.timestamp = timestamp
        isArchived = false
    }
}
