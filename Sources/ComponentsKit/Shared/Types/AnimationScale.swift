import Foundation

/// An enumeration that defines how much a component shrinks or expands during animations.
public enum AnimationScale: Hashable {
  /// No scaling is applied, meaning the component remains at its original size.
  case none
  /// A small scaling effect is applied, using a predefined value from the configuration.
  case small
  /// A medium scaling effect is applied, using a predefined value from the configuration.
  case medium
  /// A large scaling effect is applied, using a predefined value from the configuration.
  case large
  /// A custom scaling value.
  ///
  /// - Parameter value: The custom scale value (0.0–1.0).
  case custom(_ value: CGFloat)
}

extension AnimationScale {
  /// The scaling value represented as a `CGFloat`.
  ///
  /// - Returns:
  ///   - `1.0` for `.none` (no scaling).
  ///   - Predefined values from `Theme` for `.small`, `.medium`, and `.large`.
  ///   - The custom value provided for `.custom`, constrained between `0.0` and `1.0`.
  /// - Note: If the custom value is outside the range `0.0–1.0`, an assertion failure occurs,
  ///   and a default value of `1.0` is returned.
  public var value: CGFloat {
    switch self {
    case .none:
      return 1.0
    case .small:
      return Theme.current.layout.animationScale.small
    case .medium:
      return Theme.current.layout.animationScale.medium
    case .large:
      return Theme.current.layout.animationScale.large
    case .custom(let value):
      guard value >= 0 && value <= 1.0 else {
        assertionFailure("Animation scale value should be between 0 and 1")
        return 1.0
      }
      return value
    }
  }
}
