import ComponentsKit
import SwiftUI
import UIKit

struct ButtonPreview: View {
  private static let title = "Button"
  @State private var model = ButtonVM {
    $0.title = Self.title
  }
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKButton(model: self.model)
          .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUButton(model: self.model)
      }
      Form {
        AnimationScalePicker(selection: self.$model.animationScale)
        ComponentOptionalColorPicker(selection: self.$model.color)
        Picker("Content Spacing", selection: self.$model.contentSpacing) {
          Text("4").tag(CGFloat(4))
          Text("8").tag(CGFloat(8))
          Text("12").tag(CGFloat(12))
        }
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        ButtonFontPicker(selection: self.$model.font)
        Toggle("Full Width", isOn: self.$model.isFullWidth)
        Picker("Image Location", selection: self.$model.imageLocation) {
          Text("Leading").tag(ButtonVM.ImageLocation.leading)
          Text("Trailing").tag(ButtonVM.ImageLocation.trailing)
        }
        Picker("Image", selection: self.$model.image) {
          Text("SF Symbol").tag(UniversalImage(systemName: "camera.fill"))
          Text("SF Symbol (Template)").tag(
            UniversalImage(systemName: "camera.fill")
              .withRenderingMode(.template)
          )
          Text("SF Symbol (Original)").tag(
            UniversalImage(systemName: "camera.fill")
              .withRenderingMode(.original)
          )
          Text("Local").tag(UniversalImage("avatar_placeholder"))
          Text("Local (Template)").tag(
            UniversalImage("avatar_placeholder")
              .withRenderingMode(.template)
          )
          Text("Local (Original)").tag(
            UniversalImage("avatar_placeholder")
              .withRenderingMode(.original)
          )
          Text("None").tag(Optional<UniversalImage>.none)
        }
        Toggle("Loading", isOn: self.$model.isLoading)
        Toggle("Show Title", isOn: Binding<Bool>(
          get: { !self.model.title.isEmpty },
          set: { newValue in
            self.model.title = newValue ? Self.title : ""
          }
        ))
        SizePicker(selection: self.$model.size)
        ButtonStylePicker(selection: self.$model.style)
      }
    }
  }
}

#Preview {
  ButtonPreview()
}
