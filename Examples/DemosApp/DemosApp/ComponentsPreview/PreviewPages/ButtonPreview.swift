import ComponentsKit
import SwiftUI
import UIKit

struct ButtonPreview: View {
  @State private var model = ButtonVM {
    $0.title = "Button"
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
        Picker("Image Source", selection: self.$model.imageSrc) {
          Text("SF Symbol").tag(ButtonVM.ImageSource.sfSymbol("camera.fill"))
          Text("Local").tag(ButtonVM.ImageSource.local("avatar_placeholder"))
          Text("None").tag(Optional<ButtonVM.ImageSource>.none)
        }
        Toggle("Loading", isOn: self.$model.isLoading)
        Toggle("Show Title", isOn: Binding<Bool>(
          get: { !self.model.title.isEmpty },
          set: { newValue in
            self.model.title = newValue ? "Button" : ""
          }
        ))
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Filled").tag(ButtonStyle.filled)
          Text("Plain").tag(ButtonStyle.plain)
          Text("Light").tag(ButtonStyle.light)
          Text("Bordered with small border").tag(ButtonStyle.bordered(.small))
          Text("Bordered with medium border").tag(ButtonStyle.bordered(.medium))
          Text("Bordered with large border").tag(ButtonStyle.bordered(.large))
        }
      }
    }
  }
}

#Preview {
  ButtonPreview()
}
