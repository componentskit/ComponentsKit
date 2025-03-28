import SwiftUI
import UIKit

/// Defines shadow options for components.
public enum Shadow: Hashable {
  /// No shadow is applied.
  case none
  /// A small shadow.
  case small
  /// A medium shadow.
  case medium
  /// A large shadow.
  case large
  /// A custom shadow with specific parameters.
  ///
  /// - Parameters:
  ///   - radius: The blur radius of the shadow.
  ///   - offset: The offset of the shadow.
  ///   - color: The color of the shadow.
  case custom(_ radius: CGFloat, _ offset: CGSize, _ color: UniversalColor)
}

extension Shadow {
 public var radius: CGFloat {
    return switch self {
    case .none: CGFloat(0)
    case .small: Theme.current.layout.shadow.small.radius
    case .medium: Theme.current.layout.shadow.medium.radius
    case .large: Theme.current.layout.shadow.large.radius
    case .custom(let radius, _, _): radius
    }
  }

  public var offset: CGSize {
    return switch self {
    case .none: .zero
    case .small: Theme.current.layout.shadow.small.offset
    case .medium: Theme.current.layout.shadow.medium.offset
    case .large: Theme.current.layout.shadow.large.offset
    case .custom(_, let offset, _): offset
    }
  }

  public var color: UniversalColor {
    return switch self {
    case .none: .clear
    case .small: Theme.current.layout.shadow.small.color
    case .medium: Theme.current.layout.shadow.medium.color
    case .large: Theme.current.layout.shadow.large.color
    case .custom(_, _, let color): color
    }
  }
}

// MARK: - UIKit + Shadow

extension UIView {
  public func shadow(_ shadow: Shadow) {
    self.layer.shadowRadius = shadow.radius
    self.layer.shadowOffset = shadow.offset
    self.layer.shadowColor = shadow.color.cgColor
    self.layer.shadowOpacity = 1
  }
}

// MARK: - SwiftUI + Shadow

extension View {
  public func shadow(_ shadow: Shadow) -> some View {
    self.shadow(
      color: shadow.color.color,
      radius: shadow.radius,
      x: shadow.offset.width,
      y: shadow.offset.height
    )
  }
}
