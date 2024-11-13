import ComponentsKit
import Observation
import SwiftUI
import UIKit

struct TextInputPreviewPreview: View {
  @State private var model = TextInputVM {
    $0.placeholder = "Placeholder"
    $0.minRows = 1
    $0.maxRows = nil
  }

  @State private var text: String = ""
  @FocusState private var isFocused: Bool

  private let textInput = PreviewTextInput()

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          self.textInput
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUTextInput(
          text: self.$text,
          isFocused: self.$isFocused,
          model: self.model
        )
      }
      Form {
        Picker("Autocapitalization", selection: self.$model.autocapitalization) {
          Text("Never").tag(InputFieldTextAutocapitalization.never)
          Text("Characters").tag(InputFieldTextAutocapitalization.characters)
          Text("Words").tag(InputFieldTextAutocapitalization.words)
          Text("Sentences").tag(InputFieldTextAutocapitalization.sentences)
        }
        Toggle("Autocorrection Enabled", isOn: self.$model.isAutocorrectionEnabled)
        ComponentOptionalColorPicker(selection: self.$model.color)
        FontPicker(selection: self.$model.font)

        CornerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        Picker("Keyboard Type", selection: self.$model.keyboardType) {
          Text("Default").tag(UIKeyboardType.default)
          Text("asciiCapable").tag(UIKeyboardType.asciiCapable)
          Text("numbersAndPunctuation").tag(UIKeyboardType.numbersAndPunctuation)
          Text("URL").tag(UIKeyboardType.URL)
          Text("numberPad").tag(UIKeyboardType.numberPad)
          Text("phonePad").tag(UIKeyboardType.phonePad)
          Text("namePhonePad").tag(UIKeyboardType.namePhonePad)
          Text("emailAddress").tag(UIKeyboardType.emailAddress)
          Text("decimalPad").tag(UIKeyboardType.decimalPad)
          Text("twitter").tag(UIKeyboardType.twitter)
          Text("webSearch").tag(UIKeyboardType.webSearch)
          Text("asciiCapableNumberPad").tag(UIKeyboardType.asciiCapableNumberPad)
        }
        Toggle("Placeholder", isOn: .init(
          get: {
            return self.model.placeholder != nil
          },
          set: { newValue in
            self.model.placeholder = newValue ? "Placeholder" : nil
          }
        ))
        Picker("Submit Type", selection: self.$model.submitType) {
          Text("done").tag(SubmitType.done)
          Text("go").tag(SubmitType.go)
          Text("join").tag(SubmitType.join)
          Text("route").tag(SubmitType.route)
          Text("return").tag(SubmitType.return)
          Text("next").tag(SubmitType.next)
          Text("continue").tag(SubmitType.continue)
        }
        UniversalColorPicker(
          title: "Tint Color",
          selection: self.$model.tintColor
        )

        Picker("Min Rows", selection: self.$model.minRows) {
          Text("1 Row").tag(1)
          Text("2 Rows").tag(2)
        }

        Picker("Max Rows", selection: self.$model.maxRows) {
          Text("2 Rows").tag(2)
          Text("3 Rows").tag(3)
          Text("No Limit").tag(Optional<Int>.none)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        if (self.textInput.isEditing || self.isFocused) && !ProcessInfo.processInfo.isiOSAppOnMac {
          Button("Hide Keyboard") {
            self.isFocused = false
            self.textInput.resignFirstResponder()
          }
        }
      }
    }
  }
}

@Observable
private final class PreviewTextInput: UKTextInput {
  var isEditing: Bool = false

  func textViewDidBeginEditing(_ textView: UITextView) {
    self.isEditing = true
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    self.isEditing = false
  }
}

#Preview {
  TextInputPreviewPreview()
}
