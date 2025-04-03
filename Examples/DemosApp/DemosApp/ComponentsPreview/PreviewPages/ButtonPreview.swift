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
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        ButtonFontPicker(selection: self.$model.font)
        if !self.model.isLoading {
          Toggle("Enabled", isOn: self.$model.isEnabled)
        }
        Toggle("Full Width", isOn: self.$model.isFullWidth)
        Picker("Image Source", selection: self.$model.imageSrc) {
          Text("SF Symbol").tag(ButtonVM.ImageSource.sfSymbol("camera.fill"))
          Text("Local").tag(ButtonVM.ImageSource.local("avatar_placeholder"))
          Text("None").tag(Optional<ButtonVM.ImageSource>.none)
        }
        if self.model.imageSrc != nil {
          Picker("Image Location", selection: self.$model.imageLocation) {
            Text("Leading").tag(ButtonVM.ImageLocation.leading)
            Text("Trailing").tag(ButtonVM.ImageLocation.trailing)
          }
        }
        Toggle("Loading", isOn: self.$model.isLoading)
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Filled").tag(ButtonStyle.filled)
          Text("Plain").tag(ButtonStyle.plain)
          Text("Light").tag(ButtonStyle.light)
          Text("Bordered with small border").tag(ButtonStyle.bordered(.small))
          Text("Bordered with medium border").tag(ButtonStyle.bordered(.medium))
          Text("Bordered with large border").tag(ButtonStyle.bordered(.large))
        }
        .onChange(of: self.model.imageLocation) { _ in
          if self.model.isLoading {
            self.model.isLoading = false
          }
        }
        .onChange(of: self.model.imageSrc) { _ in
          if self.model.isLoading {
            self.model.isLoading = false
          }
        }
      }
    }
  }
}

#Preview {
  ButtonPreview()
}
