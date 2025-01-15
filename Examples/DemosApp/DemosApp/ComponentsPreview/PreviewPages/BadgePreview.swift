import ComponentsKit
import SwiftUI
import UIKit

struct BadgePreview: View {
  @State private var model = BadgeVM {
    $0.title = "Badge"
  }

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKBadge(model: self.model)
          .preview
      }
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
        Picker("Paddings", selection: self.$model.paddings) {
          Text("8px; 6px")
            .tag(Paddings(top: 6, leading: 8, bottom: 6, trailing: 8))
          Text("10px; 8px")
            .tag(Paddings(top: 8, leading: 10, bottom: 8, trailing: 10))
          Text("12px; 10px")
            .tag(Paddings(top: 10, leading: 12, bottom: 10, trailing: 12))
        }
      }
    }
  }
}

#Preview {
  BadgePreview()
}
