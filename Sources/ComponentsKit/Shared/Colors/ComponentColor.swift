import Foundation

/// A structure that defines a color set for components.
public struct ComponentColor: Hashable, Sendable {
  // MARK: - Properties

  /// The primary color used for the component.
  public let main: UniversalColor

  /// The contrast color, typically used for text or elements displayed on top of the `main` color.
  public let contrast: UniversalColor

  /// The background color for the component.
  public var background: UniversalColor {
    return self._background ?? self.main.withOpacity(0.15).blended(with: .background)
  }

  private let _background: UniversalColor?

  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - main: The primary color for the component.
  ///   - contrast: The color that contrasts with the `main` color, typically used for text or icons.
  ///   - background: The background color for the component. Defaults to `main` color with 15% opacity if `nil`.
  public init(
    main: UniversalColor,
    contrast: UniversalColor,
    background: UniversalColor? = nil
  ) {
    self.main = main
    self.contrast = contrast
    self._background = background
  }
}
