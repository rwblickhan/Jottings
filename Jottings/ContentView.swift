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
                        if note == notes.last, note.content != "" {
                            let newNote = Note(content: draft, timestamp: Date())
                            modelContext.insert(newNote)
                            focus = newNote.id
                        } else {
                            focus = nil
                        }
                    }, onDeleteFirstCharacter: {
                        let newFocus: UUID? = {
                            if let index = notes.firstIndex(of: note), index > 0 && note != notes.last {
                                return notes[index - 1].id
                            } else {
                                return notes.last?.id
                            }
                        }()
                        modelContext.delete(note)
                        focus = newFocus
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
