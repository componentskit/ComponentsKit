import Foundation
import SwiftUI

/// An enumeration that defines the corner radius options for components.
public enum ComponentRadius: Hashable {
  /// No corner radius, resulting in sharp edges.
  case none
  /// A small corner radius.
  case small
  /// A medium corner radius.
  case medium
  /// A large corner radius.
  case large
  /// A fully rounded corner radius, where the radius is half of the component's height.
  case full
  /// A custom corner radius with a specific value.
  ///
  /// - Parameter value: The radius value as a `CGFloat`.
  case custom(CGFloat)
}

extension ComponentRadius {
  /// Returns the numeric value of the corner radius, ensuring it does not exceed half the component's height.
  ///
  /// - Parameter height: The height of the component. Defaults to a large number (10,000) for unrestricted calculations.
  /// - Returns: The calculated corner radius as a `CGFloat`, capped at half of the height for `full` rounding or custom values.
  public func value(for height: CGFloat = 10_000) -> CGFloat {
    let maxValue = height / 2
    let value = switch self {
    case .none: CGFloat(0)
    case .small: Theme.current.layout.componentRadius.small
    case .medium: Theme.current.layout.componentRadius.medium
    case .large: Theme.current.layout.componentRadius.large
    case .full: height / 2
    case .custom(let value): value
    }
    return min(value, maxValue)
  }
}
