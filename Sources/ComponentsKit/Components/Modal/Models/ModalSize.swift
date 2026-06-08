import Foundation

/// Defines the size options for a modal.
public enum ModalSize: Sendable {
  /// A small modal size.
  case small
  /// A medium modal size.
  case medium
  /// A large modal size.
  case large
  /// A full-screen modal that occupies the entire screen.
  case full
}

extension ModalSize {
  public var maxWidth: CGFloat {
    switch self {
    case .small:
      return 300
    case .medium:
      return 400
    case .large:
      return 600
    case .full:
      return 10_000
    }
  }
}
