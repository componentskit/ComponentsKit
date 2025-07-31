import SwiftUI

struct AlertContent: View {
  @Binding var isPresented: Bool
  let model: AlertVM
  let primaryAction: (() -> Void)?
  let secondaryAction: (() -> Void)?

  var body: some View {
    SUCenterModal(
      isVisible: self.$isPresented,
      model: self.model.modalVM,
      header: {
        if self.model.message.isNotNil,
           let text = self.model.title {
          self.title(text)
        }
      },
      body: {
        if let text = self.model.message {
          self.message(text)
        } else if let text = self.model.title {
          self.title(text)
        }
      },
      footer: {
        switch AlertButtonsOrientationCalculator.preferredOrientation(model: model) {
        case .horizontal:
          HStack(spacing: AlertVM.buttonsSpacing) {
            self.button(
              model: self.model.secondaryButtonVM,
              action: self.secondaryAction
            )
            self.button(
              model: self.model.primaryButtonVM,
              action: self.primaryAction
            )
          }
        case .vertical:
          VStack(spacing: AlertVM.buttonsSpacing) {
            self.button(
              model: self.model.primaryButtonVM,
              action: self.primaryAction
            )
            self.button(
              model: self.model.secondaryButtonVM,
              action: self.secondaryAction
            )
          }
        }
      }
    )
  }

  // MARK: - Helpers

  func title(_ text: String) -> some View {
    Text(text)
      .font(UniversalFont.mdHeadline.font)
      .foregroundStyle(UniversalColor.foreground.color)
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity)
      .fixedSize(horizontal: false, vertical: true)
  }

  func message(_ text: String) -> some View {
    Text(text)
      .font(UniversalFont.mdBody.font)
      .foregroundStyle(UniversalColor.secondaryForeground.color)
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity)
  }

  func button(
    model: ButtonVM?,
    action: (() -> Void)?
  ) -> some View {
    Group {
      if let model {
        SUButton(model: model) {
          action?()
          self.isPresented = false
        }
      }
    }
  }
}

// MARK: - Presentation Helpers

extension View {
  /// A SwiftUI view modifier that presents an alert with a title, message, and up to two action buttons.
  ///
  /// All actions in an alert dismiss the alert after the action runs. If no actions are present, a standard “OK” action is included.
  ///
  /// - Parameters:
  ///   - isPresented: A binding that determines whether the alert is presented.
  ///   - model: A model that defines the appearance properties for an alert.
  ///   - primaryAction: An optional closure executed when the primary button is tapped.
  ///   - secondaryAction: An optional closure executed when the secondary button is tapped.
  ///   - onDismiss: An optional closure executed when the alert is dismissed.
  ///
  /// - Example:
  ///   ```swift
  ///   SomeView()
  ///     .suAlert(
  ///       isPresented: $isAlertPresented,
  ///       model: .init { alertVM in
  ///         alertVM.title = "My Alert"
  ///         alertVM.message = "This is an alert."
  ///         alertVM.primaryButton = .init { buttonVM in
  ///           buttonVM.title = "OK"
  ///           buttonVM.color = .primary
  ///           buttonVM.style = .filled
  ///         }
  ///         alertVM.secondaryButton = .init { buttonVM in
  ///           buttonVM.title = "Cancel"
  ///           buttonVM.style = .light
  ///         }
  ///       },
  ///       primaryAction: {
  ///         NSLog("Primary button tapped")
  ///       },
  ///       secondaryAction: {
  ///         NSLog("Secondary button tapped")
  ///       },
  ///       onDismiss: {
  ///         print("Alert dismissed")
  ///       }
  ///     )
  ///   ```
  public func suAlert(
    isPresented: Binding<Bool>,
    model: AlertVM,
    primaryAction: (() -> Void)? = nil,
    secondaryAction: (() -> Void)? = nil,
    onDismiss: (() -> Void)? = nil
  ) -> some View {
    return self.modal(
      isVisible: isPresented,
      transitionDuration: model.transition.value,
      onDismiss: onDismiss,
      content: {
        AlertContent(
          isPresented: isPresented,
          model: model,
          primaryAction: primaryAction,
          secondaryAction: secondaryAction
        )
      }
    )
  }

  /// A SwiftUI view modifier that presents an alert with a title, message, and up to two action buttons.
  ///
  /// All actions in an alert dismiss the alert after the action runs. If no actions are present, a standard “OK” action is included.
  ///
  /// - Parameters:
  ///   - isPresented: A binding that determines whether the alert is presented.
  ///   - item: A binding to an optional `Item` that determines whether the alert is presented.
  ///           When `item` is `nil`, the alert is hidden.
  ///   - primaryAction: An optional closure executed when the primary button is tapped.
  ///   - secondaryAction: An optional closure executed when the secondary button is tapped.
  ///   - onDismiss: An optional closure executed when the alert is dismissed.
  ///
  /// - Example:
  ///   ```swift
  ///   struct ContentView: View {
  ///     struct AlertData: Identifiable {
  ///       var id: String {
  ///         return text
  ///       }
  ///       let text: String
  ///     }
  ///
  ///     @State private var selectedItem: AlertData?
  ///     private let items: [AlertData] = [
  ///       AlertData(text: "data 1"),
  ///       AlertData(text: "data 2")
  ///     ]
  ///
  ///     var body: some View {
  ///       List(items) { item in
  ///         Button("Show Alert") {
  ///           selectedItem = item
  ///         }
  ///       }
  ///       .suAlert(
  ///         item: $selectedItem,
  ///         model: { data in
  ///           return AlertVM {
  ///             $0.title = "Data Preview"
  ///             $0.message = data.text
  ///           }
  ///         },
  ///         onDismiss: {
  ///           print("Alert dismissed")
  ///         }
  ///       )
  ///     }
  ///   }
  ///   ```
  public func suAlert<Item: Identifiable>(
    item: Binding<Item?>,
    model: @escaping (Item) -> AlertVM,
    primaryAction: ((Item) -> Void)? = nil,
    secondaryAction: ((Item) -> Void)? = nil,
    onDismiss: (() -> Void)? = nil
  ) -> some View {
    return self.modal(
      item: item,
      transitionDuration: { model($0).transition.value },
      onDismiss: onDismiss,
      content: { unwrappedItem in
        AlertContent(
          isPresented: .init(
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
          primaryAction: { primaryAction?(unwrappedItem) },
          secondaryAction: { secondaryAction?(unwrappedItem) }
        )
      }
    )
  }
}
