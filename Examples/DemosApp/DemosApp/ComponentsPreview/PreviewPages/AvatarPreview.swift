import ComponentsKit
import SwiftUI
import UIKit

struct AvatarPreview: View {
  @State private var model = AvatarVM {
    $0.placeholder = .image(.init("avatar_placeholder"))
  }

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKAvatar(model: self.model)
          .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUAvatar(model: self.model)
      }
      Form {
        ComponentOptionalColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 4px").tag(ComponentRadius.custom(4))
        }
        Picker("Image Source", selection: self.$model.imageSrc) {
          Text("Remote").tag(AvatarVM.ImageSource.remote(URL(string: "https://i.pravatar.cc/150?img=12")!))
          Text("Local").tag(
            AvatarVM.ImageSource.local(UniversalImage("avatar_image"))
          )
          Text("None").tag(Optional<AvatarVM.ImageSource>.none)
        }
        Picker("Placeholder", selection: self.$model.placeholder) {
          Text("Text").tag(AvatarVM.Placeholder.text("IM"))
          Text("SF Symbol").tag(
            AvatarVM.Placeholder.image(UniversalImage(systemName: "person"))
          )
          Text("Asset").tag(
            AvatarVM.Placeholder.image(UniversalImage("avatar_placeholder"))
          )
        }
        SizePicker(selection: self.$model.size)
      }
    }
  }
}

#Preview {
  AvatarPreview()
}
