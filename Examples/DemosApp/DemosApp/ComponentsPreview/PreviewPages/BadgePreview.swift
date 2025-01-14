import ComponentsKit
import SwiftUI
import UIKit

struct BadgePreview: View {
  @State private var model = BadgeVM {
    $0.title = "Badge"
  }

  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUBadge(model: self.model)
      }
      Form {
        Picker("Font", selection: self.$model.font) {
          Text("Default").tag(Optional<UniversalFont>.none)
          Text("Small").tag(UniversalFont.smButton)
          Text("Medium").tag(UniversalFont.mdButton)
          Text("Large").tag(UniversalFont.lgButton)
          Text("Custom: system bold of size 16").tag(UniversalFont.system(size: 16, weight: .bold))
        }
        ComponentOptionalColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 4px").tag(ComponentRadius.custom(4))
        }
        Picker("Style", selection: self.$model.style) {
          Text("Filled").tag(BadgeVM.Style.filled)
          Text("Light").tag(BadgeVM.Style.light)
        }
      }
    }
  }
}

#Preview {
  BadgePreview()
}
