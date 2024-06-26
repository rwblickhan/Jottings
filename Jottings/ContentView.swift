//
//  ContentView.swift
//  Jottings
//
//  Created by Russell Blickhan on 6/22/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Note> { note in !note.isArchived }, sort: \Note.timestamp)
    private var notes: [Note]

    @State private var draft: String = ""
    @FocusState private var focused: Bool

    var body: some View {
        NavigationSplitView {
            List(0 ..< 10) { index in
                if index < notes.count {
                    Text(notes[index].content)
                } else if index == notes.count && index < 10 {
                    KeyPressTextField(placeholder: "Jot something down...", text: $draft, onEmptyDelete: {
                        if index == 0 {
                            return
                        }
                        draft = notes[index - 1].content
                        modelContext.delete(notes[index - 1])
                    }, onReturn: {
                        if draft == "" {
                            return
                        }
                        modelContext.insert(Note(content: draft, timestamp: Date()))
                        draft = ""

                    })
                    .id("draft")
                    .focused($focused)
                    .onAppear {
                        focused = true
                    }
                }
            }
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            #endif
            .toolbar {
                #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                #endif
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(notes[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
