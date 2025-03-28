import Foundation

/// An enumeration that defines border thickness for components.
public enum BorderWidth: Hashable {
  /// No border.
  case none
  /// A small border width.
  case small
  /// A medium border width.
  case medium
  /// A large border width.
  case large
}

extension BorderWidth {
  /// The numeric value of the border width as a `CGFloat`.
  public var value: CGFloat {
    switch self {
    case .none:
      return 0.0
    case .small:
      return Theme.current.layout.borderWidth.small
    case .medium:
      return Theme.current.layout.borderWidth.medium
    case .large:
      return Theme.current.layout.borderWidth.large
    }
  }
}
