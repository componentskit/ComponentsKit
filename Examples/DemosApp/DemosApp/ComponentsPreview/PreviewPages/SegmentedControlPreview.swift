import ComponentsKit
import SwiftUI
import UIKit

struct SegmentedControlPreview: View {
  enum Item {
    case iPhone
    case iPad
    case mac
  }

  @State private var model = SegmentedControlVM<Item> {
    $0.items = [
      .init(id: .iPhone) {
        $0.title = "iPhone"
      },
      .init(id: .iPad) {
        $0.title = "iPad"
      },
      .init(id: .mac) {
        $0.title = "Macbook"
      }
    ]
  }

  @State private var selectedId: Item = .iPad

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKSegmentedControl(
          selectedId: .iPad,
          model: self.model
        )
        .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUSegmentedControl(
          selectedId: self.$selectedId,
          model: self.model
        )
      }
      Form {
        ComponentOptionalColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 4px").tag(ComponentRadius.custom(4))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        BodyFontPicker(selection: self.$model.font)
        Toggle("Full Width", isOn: self.$model.isFullWidth)
        SizePicker(selection: self.$model.size)
      }
    }
  }
}

#Preview {
  SegmentedControlPreview()
}
