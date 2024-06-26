//
//  ContentView.swift
//  Jottings
//
//  Created by Russell Blickhan on 6/22/24.
//

import SwiftData
import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Note> { note in !note.isArchived }, sort: \Note.timestamp)
    private var notes: [Note]

    @FocusState private var focus: UUID?
    @State private var draft: String = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(notes) { note in
                    EditableNoteRow(content: Binding(
                        get: { note.content },
                        set: { note.content = $0
                            try? modelContext.save()
                        }
                    ), onReturn: {
                        if note == notes.last && note.content != "" {
                            let newNote = Note(content: draft, timestamp: Date())
                            modelContext.insert(newNote)
                            focus = newNote.id
                        } else {
                            focus = nil
                        }
                    })
                    .focused($focus, equals: note.id)
                }
            }
            .onAppear {
                if notes.last?.content != "" {
                    let newNote = Note(content: draft, timestamp: Date())
                    modelContext.insert(newNote)
                }
                focus = notes.last?.id
            }
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            #endif
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
