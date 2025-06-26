import SwiftUI

struct ModalPresentationWithItemModifier<Modal: View, Item: Identifiable>: ViewModifier {
  @State var presentedItem: Item?
  @Binding var visibleItem: Item?

  @ViewBuilder var content: (Item) -> Modal

  let transitionDuration: (Item) -> TimeInterval
  let onDismiss: (() -> Void)?

  init(
    item: Binding<Item?>,
    transitionDuration: @escaping (Item) -> TimeInterval,
    onDismiss: (() -> Void)?,
    @ViewBuilder content: @escaping (Item) -> Modal
  ) {
    self._visibleItem = item
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
        self.presentedItem = self.visibleItem
      }
      .onChange(of: self.visibleItem.isNotNil) { isVisible in
        if isVisible {
          self.presentedItem = self.visibleItem
        } else {
          let duration = self.presentedItem.map { item in
            self.transitionDuration(item)
          } ?? 0.3
          DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.presentedItem = self.visibleItem
          }
        }
      }
      .fullScreenCover(
        item: .init(
          get: { self.presentedItem },
          set: { self.visibleItem = $0 }
        ),
        onDismiss: self.onDismiss,
        content: { item in
          self.content(item)
            .transparentPresentationBackground()
        }
      )
      .transaction {
        $0.disablesAnimations = true
      }
  }
}

extension View {
  func modal<Modal: View, Item: Identifiable>(
    item: Binding<Item?>,
    transitionDuration: @escaping (Item) -> TimeInterval,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Modal
  ) -> some View {
    modifier(ModalPresentationWithItemModifier(
      item: item,
      transitionDuration: transitionDuration,
      onDismiss: onDismiss,
      content: content
    ))
  }
}
