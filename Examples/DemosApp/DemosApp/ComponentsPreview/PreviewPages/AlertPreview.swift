import ComponentsKit
import SwiftUI
import UIKit

struct AlertPreview: View {
  @State var isAlertPresented: Bool = false
  @State private var model = AlertVM {
    $0.title = Self.alertTitle
    $0.message = AlertMessage.short.rawValue
    $0.primaryButton = Self.initialPrimaryButton
    $0.secondaryButton = Self.initialSecondaryButton
  }
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKButton(model: .init { $0.title = "Show Alert" }) {
          UIApplication.shared.topViewController?.present(
            UKAlertController(model: self.model),
            animated: true
          )
        }
        .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUButton(model: .init { $0.title = "Show Alert" }) {
          self.isAlertPresented = true
        }
        .suAlert(
          isPresented: self.$isAlertPresented,
          model: self.model
        )
      }
      Form {
        Section("Title") {
          Toggle("Has Title", isOn: .init(
            get: { return self.model.title != nil },
            set: { newValue in
              self.model.title = newValue ? Self.alertTitle : nil
            }
          ))
        }
        
        Section("Message") {
          Picker("Alert Message", selection: self.$model.message) {
            Text("None").tag(Optional<String>.none)
            Text("Short").tag(AlertMessage.short.rawValue)
            Text("Long").tag(AlertMessage.long.rawValue)
          }
        }
        
        Section("Primary Button") {
          Toggle("Has Primary Button", isOn: .init(
            get: { return self.model.primaryButton != nil },
            set: { newValue in
              self.model.primaryButton = newValue ? Self.initialPrimaryButton : nil
            }
          ))
          if self.model.primaryButton != nil {
            Picker("Title", selection: self.primaryButtonVMOrDefault.title) {
              Text("Short").tag(PrimaryButtonText.short.rawValue)
              Text("Longer").tag(PrimaryButtonText.longer.rawValue)
            }
            self.buttonPickers(for: self.primaryButtonVMOrDefault)
          }
        }
        
        Section("Secondary Button") {
          Toggle("Has Secondary Button", isOn: .init(
            get: { return self.model.secondaryButton != nil },
            set: { newValue in
              self.model.secondaryButton = newValue ? Self.initialSecondaryButton : nil
            }
          ))
          if self.model.secondaryButton != nil {
            Picker("Title", selection: self.secondaryButtonVMOrDefault.title) {
              Text("Short").tag(SecondaryButtonText.short.rawValue)
              Text("Longer").tag(SecondaryButtonText.longer.rawValue)
            }
            self.buttonPickers(for: self.secondaryButtonVMOrDefault)
          }
        }
        
        Section("Main Properties") {
          Picker("Background Color", selection: self.$model.backgroundColor) {
            Text("Default").tag(Optional<UniversalColor>.none)
            Text("Accent Background").tag(UniversalColor.accentBackground)
            Text("Success Background").tag(UniversalColor.successBackground)
            Text("Warning Background").tag(UniversalColor.warningBackground)
            Text("Danger Background").tag(UniversalColor.dangerBackground)
          }
          BorderWidthPicker(selection: self.$model.borderWidth)
          Toggle("Closes On Overlay Tap", isOn: self.$model.closesOnOverlayTap)
          Picker("Content Paddings", selection: self.$model.contentPaddings) {
            Text("12px").tag(Paddings(padding: 12))
            Text("16px").tag(Paddings(padding: 16))
            Text("20px").tag(Paddings(padding: 20))
          }
          ContainerRadiusPicker(selection: self.$model.cornerRadius) {
            Text("Custom 30px").tag(ContainerRadius.custom(30))
          }
          OverlayStylePicker(selection: self.$model.overlayStyle)
          TransitionPicker(selection: self.$model.transition)
        }
      }
    }
  }
  
  // MARK: - Reusable Pickers
  
  private func buttonPickers(for buttonVM: Binding<AlertButtonVM>) -> some View {
    Group {
      AnimationScalePicker(selection: buttonVM.animationScale)
      ComponentOptionalColorPicker(selection: buttonVM.color)
      ComponentRadiusPicker(selection: buttonVM.cornerRadius) {
        Text("Custom: 20px").tag(ComponentRadius.custom(20))
      }
      Picker("Style", selection: buttonVM.style) {
        Text("Filled").tag(ButtonStyle.filled)
        Text("Plain").tag(ButtonStyle.plain)
        Text("Light").tag(ButtonStyle.light)
        Text("Bordered with small border").tag(ButtonStyle.bordered(.small))
        Text("Bordered with medium border").tag(ButtonStyle.bordered(.medium))
        Text("Bordered with large border").tag(ButtonStyle.bordered(.large))
      }
    }
  }
  
  // MARK: - Helpers

  enum AlertMessage: String {
    case short = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    case long = """
Lorem ipsum odor amet, consectetuer adipiscing elit. Vitae vehicula pellentesque lectus orci fames. Cras suscipit dui tortor penatibus turpis ultrices. Laoreet montes adipiscing ante dapibus facilisis. Lorem per fames nec duis quis eleifend imperdiet. Tincidunt id interdum adipiscing eros dis quis platea varius. Potenti eleifend eu molestie laoreet varius sapien. Adipiscing nascetur platea penatibus curabitur tempus nibh laoreet porttitor. Augue et curabitur cras sed semper inceptos nunc montes mollis.

Lectus arcu pellentesque inceptos tempor fringilla nascetur. Erat curae convallis integer mi, quis facilisi tortor. Phasellus aliquam molestie vehicula odio in dis maximus diam elit. Rutrum gravida amet euismod feugiat fusce. Est egestas velit vulputate senectus sociosqu fringilla eget nibh. Nam pellentesque aenean mi platea tincidunt quam sem purus. Himenaeos suspendisse nec sapien habitasse ultricies maecenas libero odio. Rutrum senectus maximus ultrices, ad nam ultricies placerat.

Enim habitant laoreet inceptos scelerisque senectus, tellus molestie ut. Eros risus nibh morbi eu aenean. Velit ligula magnis aliquet at luctus. Dapibus vestibulum consectetur euismod vitae per ultrices litora quis. Aptent eleifend dapibus urna lacinia felis nisl. Sit amet fusce nullam feugiat posuere. Urna amet curae velit fermentum interdum vestibulum penatibus. Penatibus vivamus sem ultricies pellentesque congue id mattis diam. Aliquam efficitur mi gravida sollicitudin; amet imperdiet. Rutrum mollis risus justo tortor in duis cursus.
"""
  }
  enum PrimaryButtonText: String {
    case short = "Continue"
    case longer = "Remind me later"
  }
  enum SecondaryButtonText: String {
    case short = "Cancel"
    case longer = "Cancel, Don't Do That"
  }
  static let alertTitle = "Alert Title"
  static let initialPrimaryButton = AlertButtonVM {
    $0.title = PrimaryButtonText.short.rawValue
    $0.style = .filled
    $0.color = .primary
  }
  static let initialSecondaryButton = AlertButtonVM {
    $0.title = SecondaryButtonText.short.rawValue
    $0.style = .plain
  }
  
  var primaryButtonVMOrDefault: Binding<AlertButtonVM> {
    return .init(
      get: { self.model.primaryButton ?? Self.initialPrimaryButton },
      set: { self.model.primaryButton = $0 }
    )
  }
  var secondaryButtonVMOrDefault: Binding<AlertButtonVM> {
    return .init(
      get: { self.model.secondaryButton ?? Self.initialSecondaryButton },
      set: { self.model.secondaryButton = $0 }
    )
  }
}

#Preview {
  AlertPreview()
}
