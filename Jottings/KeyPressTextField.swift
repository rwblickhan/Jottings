//
//  KeyPressTextField.swift
//  Jottings
//
//  Created by Russell Blickhan on 6/25/24.
//

import Foundation
import SwiftUI

struct KeyPressTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var onEmptyDelete: () -> Void
    var onReturn: () -> Void

    func makeUIView(context: Context) -> BackwardDeletionUITextField {
        let textField = BackwardDeletionUITextField()
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        textField.onDeleteBackward = { [weak textField] in
            if textField?.text?.isEmpty == true {
                context.coordinator.parent.onEmptyDelete()
            }
        }
        return textField
    }

    func updateUIView(_ uiView: BackwardDeletionUITextField, context _: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: KeyPressTextField

        init(_ parent: KeyPressTextField) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_: UITextField) -> Bool {
            parent.onReturn()
            return true
        }
    }
}

class BackwardDeletionUITextField: UITextField {
    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        onDeleteBackward?()
        super.deleteBackward()
    }
}
