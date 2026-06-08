import SwiftUI

struct ModalOverlay<VM: ModalVM>: View {
  let model: VM

  @Binding var isVisible: Bool

  init(
    isVisible: Binding<Bool>,
    model: VM
  ) {
    self._isVisible = isVisible
    self.model = model
  }

  var body: some View {
    Group {
      switch self.model.overlayStyle {
      case .dimmed:
        Color.black.opacity(0.35)
      case .blurred:
        Color.clear.background(.ultraThinMaterial)
      case .transparent:
        // Note: The tap gesture isn't recognized when a completely transparent
        // color is clicked. This can be fixed by calling contentShape, which
        // defines the interactive area of the underlying view.
        Color.clear.contentShape(.rect)
      }
    }
    .ignoresSafeArea(.all)
    .onTapGesture {
      if self.model.closesOnOverlayTap {
        self.isVisible = false
      }
    }
  }
}
