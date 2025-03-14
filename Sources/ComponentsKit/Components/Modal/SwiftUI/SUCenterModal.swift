import SwiftUI

struct SUCenterModal<Header: View, Body: View, Footer: View>: View {
  let model: CenterModalVM

  @Binding var isVisible: Bool

  @ViewBuilder let contentHeader: () -> Header
  @ViewBuilder let contentBody: () -> Body
  @ViewBuilder let contentFooter: () -> Footer

  @State private var contentOpacity: CGFloat = 0

  init(
    isVisible: Binding<Bool>,
    model: CenterModalVM,
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
    ZStack(alignment: .center) {
      ModalOverlay(isVisible: self.$isVisible, model: self.model)

      ModalContent(model: self.model, header: self.contentHeader, body: self.contentBody, footer: self.contentFooter)
    }
    .opacity(self.contentOpacity)
    .onAppear {
      withAnimation(.linear(duration: self.model.transition.value)) {
        self.contentOpacity = 1.0
      }
    }
    .onChange(of: self.isVisible) { newValue in
      withAnimation(.linear(duration: self.model.transition.value)) {
        if newValue {
          self.contentOpacity = 1.0
        } else {
          self.contentOpacity = 0.0
        }
      }
    }
  }
}

// MARK: - Presentation Helpers

extension View {
  /// A SwiftUI view modifier that presents a center-aligned modal.
  ///
  /// This modifier allows you to attach a center modal to any SwiftUI view, providing a structured way to display modals
  /// with a header, body, and footer, all styled and laid out according to the provided `CenterModalVM` model.
  ///
  /// - Parameters:
  ///   - isPresented: A binding that determines whether the modal is presented.
  ///   - model: A model that defines the appearance properties.
  ///   - onDismiss: An optional closure executed when the modal is dismissed.
  ///   - header: A closure that provides the view for the modal's header.
  ///   - body: A closure that provides the view for the modal's main content.
  ///   - footer: A closure that provides the view for the modal's footer.
  ///
  /// - Returns: A modified `View` with a center modal attached.
  ///
  /// - Example:
  ///   ```swift
  ///   SomeView()
  ///     .centerModal(
  ///       isPresented: $isModalPresented,
  ///       model: CenterModalVM(),
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
  public func centerModal<Header: View, Body: View, Footer: View>(
    isPresented: Binding<Bool>,
    model: CenterModalVM = .init(),
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
        SUCenterModal(
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
  /// A SwiftUI view modifier that presents a center-aligned modal bound to an optional identifiable item.
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
  /// - Returns: A modified `View` with a center modal attached.
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
  ///       .centerModal(
  ///         item: $selectedItem,
  ///         model: { _ in CenterModalVM() },
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
  public func centerModal<Item: Identifiable, Header: View, Body: View, Footer: View>(
    item: Binding<Item?>,
    model: @escaping (Item) -> CenterModalVM = { _ in .init() },
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
        SUCenterModal(
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

  /// A SwiftUI view modifier that presents a center-aligned modal bound to an optional identifiable item.
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
  /// - Returns: A modified `View` with a center modal attached.
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
  ///       .centerModal(
  ///         item: $selectedItem,
  ///         model: { _ in CenterModalVM() },
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
  public func centerModal<Item: Identifiable, Body: View>(
    item: Binding<Item?>,
    model: @escaping (Item) -> CenterModalVM = { _ in .init() },
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder body: @escaping (Item) -> Body
  ) -> some View {
    return self.centerModal(
      item: item,
      model: model,
      header: { _ in EmptyView() },
      body: body,
      footer: { _ in EmptyView() }
    )
  }
}
