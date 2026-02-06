import ComponentsKit
import SwiftUI
import UIKit

struct AvatarGroupPreview: View {
  @State private var model = AvatarGroupVM {
    $0.items = [
      .init {
        $0.imageSrc = .remote(URL(string: "https://i.pravatar.cc/150?img=12")!)
      },
      .init {
        $0.imageSrc = .remote(URL(string: "https://i.pravatar.cc/150?img=14")!)
      },
      .init {
        $0.imageSrc = .remote(URL(string: "https://i.pravatar.cc/150?img=15")!)
      },
      .init(),
      .init(),
      .init {
        $0.placeholder = .text("IM")
      },
      .init {
        $0.placeholder = .image(.init(systemName: "person.circle"))
      },
    ]
  }
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKAvatarGroup(model: self.model)
          .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUAvatarGroup(model: self.model)
      }
      Form {
        Picker("Border Color", selection: self.$model.borderColor) {
          Text("Background").tag(UniversalColor.background)
          Text("Accent Background").tag(ComponentColor.accent.background)
          Text("Success Background").tag(ComponentColor.success.background)
          Text("Warning Background").tag(ComponentColor.warning.background)
          Text("Danger Background").tag(ComponentColor.danger.background)
        }
        ComponentOptionalColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 4px").tag(ComponentRadius.custom(4))
        }
        Picker("Max Visible Avatars", selection: self.$model.maxVisibleAvatars) {
          Text("3").tag(3)
          Text("5").tag(5)
          Text("7").tag(7)
        }
        SizePicker(selection: self.$model.size)
      }
    }
  }
}

#Preview {
  AvatarGroupPreview()
}
