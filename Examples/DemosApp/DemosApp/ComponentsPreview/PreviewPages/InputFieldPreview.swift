import ComponentsKit
import Observation
import SwiftUI
import UIKit

struct InputFieldPreview: View {
  @State private var model = Self.initialModel

  @State private var text: String = ""
  @FocusState private var isFocused: Bool

  @ObservedObject private var inputField = PreviewInputField(model: Self.initialModel)

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        self.inputField
          .preview
          .onAppear {
            self.inputField.text = ""
            self.inputField.model = Self.initialModel
          }
          .onChange(of: self.model) { newValue in
            self.inputField.model = newValue
          }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUInputField(
          text: self.$text,
          isFocused: self.$isFocused,
          model: self.model
        )
      }
      Form {
        AutocapitalizationPicker(selection: self.$model.autocapitalization)
        Toggle("Autocorrection Enabled", isOn: self.$model.isAutocorrectionEnabled)
        Toggle("Caption", isOn: .init(
          get: {
            return self.model.caption != nil
          },
          set: { newValue in
            self.model.caption = newValue ? Self.caption : nil
          }
        ))
        CaptionFontPicker(title: "Caption Font", selection: self.$model.captionFont)
        ComponentOptionalColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        BodyFontPicker(selection: self.$model.font)
        KeyboardTypePicker(selection: self.$model.keyboardType)
        Toggle("Placeholder", isOn: .init(
          get: {
            return self.model.placeholder != nil
          },
          set: { newValue in
            self.model.placeholder = newValue ? Self.placeholder : nil
          }
        ))
        Toggle("Required", isOn: self.$model.isRequired)
        Toggle("Secure Input", isOn: self.$model.isSecureInput)
        SizePicker(selection: self.$model.size)
        InputStylePicker(selection: self.$model.style)
        SubmitTypePicker(selection: self.$model.submitType)
        UniversalColorPicker(
          title: "Tint Color",
          selection: self.$model.tintColor
        )
        Toggle("Title", isOn: .init(
          get: {
            return self.model.title != nil
          },
          set: { newValue in
            self.model.title = newValue ? Self.title : nil
          }
        ))
        BodyFontPicker(title: "Title Font", selection: self.$model.titleFont)
        Picker("Title Position", selection: self.$model.titlePosition) {
          Text("Inside").tag(InputFieldVM.TitlePosition.inside)
          Text("Outside").tag(InputFieldVM.TitlePosition.outside)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        if (self.inputField.isEditing || self.isFocused) && !ProcessInfo.processInfo.isiOSAppOnMac {
          Button("Hide Keyboard") {
            self.isFocused = false
            self.inputField.resignFirstResponder()
          }
        }
      }
    }
  }

  private static let title = "Email"
  private static let placeholder = "Enter your email"
  private static let caption = "Your email address will be used to send a verification code"
  private static var initialModel: InputFieldVM {
    return .init {
      $0.title = Self.title
      $0.placeholder = Self.placeholder
      $0.caption = Self.caption
    }
  }
}

private final class PreviewInputField: UKInputField, ObservableObject, UITextFieldDelegate {
  @Published var isEditing: Bool = false

  override init(
    initialText: String = "",
    model: InputFieldVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    super.init(initialText: initialText, model: model, onValueChange: onValueChange)

    self.textField.delegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.isEditing = true
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.isEditing = false
  }
}

#Preview {
  InputFieldPreview()
}
