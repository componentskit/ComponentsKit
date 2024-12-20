import SwiftUI

/// A SwiftUI component that performs an action when it is tapped by a user.
public struct SUButton: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: ButtonVM
  /// A closure that is triggered when the button is tapped.
  public var action: () -> Void

  /// A Boolean value indicating whether the button is pressed.
  @State public var isPressed: Bool = false

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - action: A closure that is triggered when the button is tapped.
  public init(
    model: ButtonVM,
    action: @escaping () -> Void = {}
  ) {
    self.model = model
    self.action = action
  }

  // MARK: Body

  public var body: some View {
    Button(self.model.title, action: self.action)
      .buttonStyle(CustomButtonStyle(model: self.model))
      .simultaneousGesture(DragGesture(minimumDistance: 0.0)
        .onChanged { _ in
          self.isPressed = true
        }
        .onEnded { _ in
          self.isPressed = false
        }
      )
      .disabled(!self.model.isEnabled)
      .scaleEffect(
        self.isPressed ? self.model.animationScale.value : 1,
        anchor: .center
      )
  }
}

// MARK: - Helpers

private struct CustomButtonStyle: SwiftUI.ButtonStyle {
  let model: ButtonVM

  @Environment(\.colorScheme) var colorScheme

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(self.model.preferredFont.font)
      .lineLimit(1)
      .padding(.leading, self.model.horizontalPadding)
      .padding(.trailing, self.model.horizontalPadding)
      .frame(maxWidth: self.model.width)
      .frame(height: self.model.height)
      .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
      .background(
        self.model.backgroundColor?.color(for: self.colorScheme) ?? Color.clear
      )
      .clipShape(
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
      )
      .overlay {
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
        .stroke(
          self.model.borderColor?.color(for: self.colorScheme) ?? .clear,
          lineWidth: self.model.borderWidth
        )
      }
  }
}
