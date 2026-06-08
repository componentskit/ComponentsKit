import ComponentsKit
import SwiftUI
import UIKit

struct UKComponentPreview<View, Model>: UIViewRepresentable where View: UKComponent, Model == View.Model {
  class Container: UIView {
    let component: View

    init(component: View) {
      self.component = component

      super.init(frame: .zero)

      self.addSubview(self.component)

      self.component.centerVertically()
      self.component.centerHorizontally()

      self.component.topAnchor.constraint(
        greaterThanOrEqualTo: self.topAnchor
      ).isActive = true
      self.component.bottomAnchor.constraint(
        lessThanOrEqualTo: self.bottomAnchor
      ).isActive = true
      self.component.leadingAnchor.constraint(
        greaterThanOrEqualTo: self.leadingAnchor
      ).isActive = true
      self.component.trailingAnchor.constraint(
        lessThanOrEqualTo: self.trailingAnchor
      ).isActive = true
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  let model: Model
  let view: View

  @MainActor
  init(view: View) {
    self.view = view
    self.model = view.model
  }

  func makeUIView(context: Context) -> Container {
    return Container(component: self.view)
  }

  func updateUIView(_ container: Container, context: Context) {
    container.component.model = self.model
  }
}

extension UKComponent {
  @MainActor
  var preview: some View {
    UKComponentPreview(view: self)
  }
}
