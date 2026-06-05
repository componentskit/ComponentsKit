import Foundation

/// A model that defines generic appearance properties that can be in any modal component.
public protocol ModalVM: ComponentVM {
  /// The background color of the modal.
  var backgroundColor: UniversalColor? { get set }

  /// Defines how modal renders its background.
  var backgroundStyle: BackgroundStyle { get set }

  /// The border thickness of the modal.
  var borderWidth: BorderWidth { get set }

  /// A Boolean value indicating whether the modal should close when tapping on the overlay.
  var closesOnOverlayTap: Bool { get set }

  /// The padding applied to the modal's content area.
  var contentPaddings: Paddings { get set }

  /// The spacing between header, body and footer.
  var contentSpacing: CGFloat { get set }

  /// The corner radius of the modal.
  var cornerRadius: ContainerRadius { get set }

  /// The style of the overlay displayed behind the modal.
  var overlayStyle: ModalOverlayStyle { get set }

  /// The padding applied outside the modal's content area, creating space between the modal and the screen edges.
  var outerPaddings: Paddings { get set }

  /// The predefined maximum size of the modal.
  var size: ModalSize { get set }

  /// The transition duration of the modal's appearance and dismissal animations.
  var transition: ModalTransition { get set }
}

// MARK: - Helpers

extension ModalVM {
  var preferredBackgroundColor: UniversalColor? {
    switch self.backgroundStyle {
    case .solid:
      return self.backgroundColor ?? .themed(
        light: UniversalColor.background.light,
        dark: UniversalColor.secondaryBackground.dark
      )
    case .liquidGlass, .blur:
      return nil
    }
  }
}
