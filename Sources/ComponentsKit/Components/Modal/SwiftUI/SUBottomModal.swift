import SwiftUI

struct SUBottomModal<Header: View, Body: View, Footer: View>: View {
  let model: BottomModalVM

  @Binding var isVisible: Bool

  @ViewBuilder let contentHeader: () -> Header
  @ViewBuilder let contentBody: () -> Body
  @ViewBuilder let contentFooter: () -> Footer

  @State private var contentHeight: CGFloat = 0
  @State private var contentOffsetY: CGFloat = 0
  @State private var overlayOpacity: CGFloat = 0

  init(
    isVisible: Binding<Bool>,
    model: BottomModalVM,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer
  ) {
    self._isVisible = isVisible
    self.model = model
    self.contentHeader = header
    self.contentBody = body
    self.contentFooter = footer
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      ModalOverlay(isVisible: self.$isVisible, model: self.model)
        .opacity(self.overlayOpacity)

      ModalContent(model: self.model, header: self.contentHeader, body: self.contentBody, footer: self.contentFooter)
        .observeSize {
          self.contentHeight = $0.height
        }
        .offset(y: self.contentOffsetY)
        .gesture(
          DragGesture()
            .onChanged { gesture in
              let translation = gesture.translation.height
              self.contentOffsetY = ModalAnimation.bottomModalOffset(translation, model: self.model)
            }
            .onEnded { gesture in
              if ModalAnimation.shouldHideBottomModal(
                offset: self.contentOffsetY,
                height: self.contentHeight,
                velocity: gesture.velocity.height,
                model: self.model
              ) {
                self.isVisible = false
              } else {
                withAnimation(.linear(duration: 0.2)) {
                  self.contentOffsetY = 0
                }
              }
            }
        )
    }
    .onAppear {
      self.contentOffsetY = self.screenHeight

      withAnimation(.linear(duration: self.model.transition.value)) {
        self.overlayOpacity = 1.0
        self.contentOffsetY = 0
      }
    }
    .onChange(of: self.isVisible) { newValue in
      withAnimation(.linear(duration: self.model.transition.value)) {
        if newValue {
          self.overlayOpacity = 1.0
          self.contentOffsetY = 0
        } else {
          self.overlayOpacity = 0.0
          self.contentOffsetY = self.screenHeight
        }
      }
    }
  }

  // MARK: - Helpers

  private var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
  }
}

// MARK: - Presentation Helpers

extension View {
  /// A SwiftUI view modifier that presents a bottom-aligned modal.
  ///
  /// This modifier allows you to attach a bottom modal to any SwiftUI view, providing a structured way to display modals
  /// with a header, body, and footer, all styled and laid out according to the provided `BottomModalVM` model.
  ///
  /// - Parameters:
  ///   - isPresented: A binding that determines whether the modal is presented.
  ///   - model: A model that defines the appearance properties.
  ///   - onDismiss: An optional closure executed when the modal is dismissed.
  ///   - header: A closure that provides the view for the modal's header.
  ///   - body: A closure that provides the view for the modal's main content.
  ///   - footer: A closure that provides the view for the modal's footer.
  ///
  /// - Returns: A modified `View` with a bottom modal attached.
  ///
  /// - Example:
  ///   ```swift
  ///   SomeView()
  ///     .bottomModal(
  ///       isPresented: $isModalPresented,
  ///       model: BottomModalVM(),
  ///       onDismiss: {
  ///         print("Modal dismissed")
  ///       },
  ///       header: {
  ///         Text("Header")
  ///       },
  ///       body: {
  ///         Text("Body content goes here")
  ///       },
  ///       footer: {
  ///         SUButton(model: .init {
  ///           $0.title = "Close"
  ///         }) {
  ///           isModalPresented = false
  ///         }
  ///       }
  ///     )
  ///   ```
  public func bottomModal<Header: View, Body: View, Footer: View>(
    isPresented: Binding<Bool>,
    model: BottomModalVM = .init(),
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder header: @escaping () -> Header = { EmptyView() },
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
  ) -> some View {
    return self.modal(
      isVisible: isPresented,
      transitionDuration: model.transition.value,
      onDismiss: onDismiss,
      content: {
        SUBottomModal(
          isVisible: isPresented,
          model: model,
          header: header,
          body: body,
          footer: footer
        )
      }
    )
  }
}

extension View {
  /// A SwiftUI view modifier that presents a bottom-aligned modal bound to an optional identifiable item.
  ///
  /// This modifier allows you to attach a modal to any SwiftUI view, which is displayed when the `item` binding
  /// is non-`nil`. The modal content is dynamically generated based on the unwrapped `Item`.
  ///
  /// - Parameters:
  ///   - item: A binding to an optional `Item` that determines whether the modal is presented.
  ///           When `item` is `nil`, the modal is hidden.
  ///   - model: A model that defines the appearance properties.
  ///   - onDismiss: An optional closure executed when the modal is dismissed. Defaults to `nil`.
  ///   - header: A closure that provides the view for the modal's header, based on the unwrapped `Item`.
  ///   - body: A closure that provides the view for the modal's main content, based on the unwrapped `Item`.
  ///   - footer: A closure that provides the view for the modal's footer, based on the unwrapped `Item`.
  ///
  /// - Returns: A modified `View` with a bottom modal attached.
  ///
  /// - Example:
  ///   ```swift
  ///   struct ContentView: View {
  ///     struct ModalData: Identifiable {
  ///       var id: String {
  ///         return text
  ///       }
  ///       let text: String
  ///     }
  ///
  ///     @State private var selectedItem: ModalData?
  ///     private let items: [ModalData] = [
  ///       ModalData(text: "data 1"),
  ///       ModalData(text: "data 2")
  ///     ]
  ///
  ///     var body: some View {
  ///       List(items) { item in
  ///         Button("Show Modal") {
  ///           selectedItem = item
  ///         }
  ///       }
  ///       .bottomModal(
  ///         item: $selectedItem,
  ///         model: { _ in BottomModalVM() },
  ///         onDismiss: {
  ///           print("Modal dismissed")
  ///         },
  ///         header: { item in
  ///           Text("Header for \(item.text)")
  ///         },
  ///         body: { item in
  ///           Text("Body content for \(item.text)")
  ///         },
  ///         footer: { _ in
  ///           SUButton(model: .init {
  ///             $0.title = "Close"
  ///           }) {
  ///             selectedItem = nil
  ///           }
  ///         }
  ///       )
  ///     }
  ///   }
  ///   ```
  public func bottomModal<Item: Identifiable, Header: View, Body: View, Footer: View>(
    item: Binding<Item?>,
    model: @escaping (Item) -> BottomModalVM = { _ in .init() },
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder header: @escaping (Item) -> Header,
    @ViewBuilder body: @escaping (Item) -> Body,
    @ViewBuilder footer: @escaping (Item) -> Footer
  ) -> some View {
    return self.modal(
      item: item,
      transitionDuration: { model($0).transition.value },
      onDismiss: onDismiss,
      content: { unwrappedItem in
        SUBottomModal(
          isVisible: .init(
            get: {
              return item.wrappedValue.isNotNil
            },
            set: { isPresented in
              if isPresented {
                item.wrappedValue = unwrappedItem
              } else {
                item.wrappedValue = nil
              }
            }
          ),
          model: model(unwrappedItem),
          header: { header(unwrappedItem) },
          body: { body(unwrappedItem) },
          footer: { footer(unwrappedItem) }
        )
      }
    )
  }

  /// A SwiftUI view modifier that presents a bottom-aligned modal bound to an optional identifiable item.
  ///
  /// This modifier allows you to attach a modal to any SwiftUI view, which is displayed when the `item` binding
  /// is non-`nil`. The modal content is dynamically generated based on the unwrapped `Item`.
  ///
  /// - Parameters:
  ///   - item: A binding to an optional `Item` that determines whether the modal is presented.
  ///           When `item` is `nil`, the modal is hidden.
  ///   - model: A model that defines the appearance properties.
  ///   - onDismiss: An optional closure executed when the modal is dismissed. Defaults to `nil`.
  ///   - body: A closure that provides the view for the modal's main content, based on the unwrapped `Item`.
  ///
  /// - Returns: A modified `View` with a bottom modal attached.
  ///
  /// - Example:
  ///   ```swift
  ///   struct ContentView: View {
  ///     struct ModalData: Identifiable {
  ///       var id: String {
  ///         return text
  ///       }
  ///       let text: String
  ///     }
  ///
  ///     @State private var selectedItem: ModalData?
  ///     private let items: [ModalData] = [
  ///       ModalData(text: "data 1"),
  ///       ModalData(text: "data 2")
  ///     ]
  ///
  ///     var body: some View {
  ///       List(items) { item in
  ///         Button("Show Modal") {
  ///           selectedItem = item
  ///         }
  ///       }
  ///       .bottomModal(
  ///         item: $selectedItem,
  ///         model: { _ in BottomModalVM() },
  ///         onDismiss: {
  ///           print("Modal dismissed")
  ///         },
  ///         body: { item in
  ///           Text("Body content for \(item.text)")
  ///         }
  ///       )
  ///     }
  ///   }
  ///   ```
  public func bottomModal<Item: Identifiable, Body: View>(
    item: Binding<Item?>,
    model: @escaping (Item) -> BottomModalVM = { _ in .init() },
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder body: @escaping (Item) -> Body
  ) -> some View {
    return self.bottomModal(
      item: item,
      model: model,
      header: { _ in EmptyView() },
      body: body,
      footer: { _ in EmptyView() }
    )
  }
}
