//
//  EditableNoteRow.swift
//  Jottings
//
//  Created by Russell Blickhan on 6/25/24.
//

import SwiftUI

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var onReturn: (() -> Void)?

    func textFieldShouldReturn(_: UITextField) -> Bool {
        onReturn?()
        return false
    }
}

struct EditableNoteRow: View {
    var textFieldDelegate = TextFieldDelegate()
    @Binding var content: String
    var onReturn: () -> Void

    var body: some View {
        TextField("Jot something down...", text: $content)
            .introspect(.textField, on: .iOS(.v16, .v17), customize: { textField in
                textFieldDelegate.onReturn = onReturn
                textField.delegate = textFieldDelegate
            })
    }
}

#Preview {
    EditableNoteRow(content: .constant("Note note note...")) {}
}
