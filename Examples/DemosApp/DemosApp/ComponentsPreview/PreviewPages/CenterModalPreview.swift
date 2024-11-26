import ComponentsKit
import SwiftUI
import UIKit

struct CenterModalPreview: View {
  @State var model = CenterModalVM()

  var body: some View {
    ModalPreview(
      model: self.$model,
      presentController: { header, body, footer in
        UIApplication.shared.topViewController?.present(
          UKCenterModalController(
            model: self.model,
            header: header,
            body: body,
            footer: footer
          ),
          animated: true
        )
      },
      additionalPickers: {
        EmptyView()
      }
    )
  }
}

#Preview {
  CenterModalPreview()
}
