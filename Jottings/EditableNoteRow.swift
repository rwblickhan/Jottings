//
//  EditableNoteRow.swift
//  Jottings
//
//  Created by Russell Blickhan on 6/25/24.
//

import SwiftUI

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var onReturn: (() -> Void)?
    var onDeleteFirstCharacter: (() -> Void)?

    func textFieldShouldReturn(_: UITextField) -> Bool {
        onReturn?()
        return false
    }
<<<<<<< Updated upstream
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && range.length > 0 {
||||||| Stash base
=======

    func textField(_: UITextField, shouldChangeCharactersIn range: NSRange, replacementString _: String) -> Bool {
        if range.location == 0, range.length > 0 {
>>>>>>> Stashed changes
            onDeleteFirstCharacter?()
        }
        return true
    }
}

struct EditableNoteRow: View {
    var textFieldDelegate = TextFieldDelegate()
    @Binding var content: String
    var onReturn: () -> Void
    var onDeleteFirstCharacter: () -> Void

    var body: some View {
        TextField("Jot something down...", text: $content)
            .introspect(.textField, on: .iOS(.v16, .v17), customize: { textField in
                textFieldDelegate.onReturn = onReturn
                textFieldDelegate.onDeleteFirstCharacter = onDeleteFirstCharacter
                textField.delegate = textFieldDelegate
            })
    }
}

#Preview {
    EditableNoteRow(content: .constant("Note note note..."), onReturn: {}, onDeleteFirstCharacter: {})
}
