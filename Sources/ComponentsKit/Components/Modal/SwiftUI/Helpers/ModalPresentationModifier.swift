import SwiftUI

struct ModalPresentationModifier<Modal: View>: ViewModifier {
  @State var isPresented: Bool = false
  @Binding var isContentVisible: Bool

  @ViewBuilder var content: () -> Modal

  let transitionDuration: TimeInterval
  let onDismiss: (() -> Void)?

  init(
    isVisible: Binding<Bool>,
    transitionDuration: TimeInterval,
    onDismiss: (() -> Void)?,
    @ViewBuilder content: @escaping () -> Modal
  ) {
    self._isContentVisible = isVisible
    self.transitionDuration = transitionDuration
    self.onDismiss = onDismiss
    self.content = content
  }

  func body(content: Content) -> some View {
    content
      .transaction {
        $0.disablesAnimations = false
      }
      .onAppear {
        if self.isContentVisible {
          self.isPresented = true
        }
      }
      .onChange(of: self.isContentVisible) { isVisible in
        if isVisible {
          self.isPresented = true
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + self.transitionDuration) {
            self.isPresented = false
          }
        }
      }
      .fullScreenCover(
        isPresented: .init(
          get: { self.isPresented },
          set: { self.isContentVisible = $0 }
        ),
        onDismiss: self.onDismiss,
        content: {
          self.content()
            .transparentPresentationBackground()
        }
      )
      .transaction {
        $0.disablesAnimations = true
      }
  }
}

extension View {
  func modal<Modal: View>(
    isVisible: Binding<Bool>,
    transitionDuration: TimeInterval,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Modal
  ) -> some View {
    modifier(ModalPresentationModifier(
      isVisible: isVisible,
      transitionDuration: transitionDuration,
      onDismiss: onDismiss,
      content: content
    ))
  }
}
