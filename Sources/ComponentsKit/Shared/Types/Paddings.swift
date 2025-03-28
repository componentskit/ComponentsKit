import SwiftUI
import UIKit

/// Defines padding values for each edge.
public struct Paddings: Hashable {
  /// The padding value for the top edge.
  public var top: CGFloat

  /// The padding value for the leading edge.
  public var leading: CGFloat

  /// The padding value for the bottom edge.
  public var bottom: CGFloat

  /// The padding value for the trailing edge.
  public var trailing: CGFloat

  /// Initializes a new `Paddings` instance with specific values for all edges.
  ///
  /// - Parameters:
  ///   - top: The padding value for the top edge.
  ///   - leading: The padding value for the leading edge.
  ///   - bottom: The padding value for the bottom edge.
  ///   - trailing: The padding value for the trailing edge.
  public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }

  /// Initializes a new `Paddings` instance with uniform horizontal and vertical values.
  ///
  /// - Parameters:
  ///   - horizontal: The padding value applied to both the leading and trailing edges.
  ///   - vertical: The padding value applied to both the top and bottom edges.
  public init(horizontal: CGFloat, vertical: CGFloat) {
    self.top = vertical
    self.leading = horizontal
    self.bottom = vertical
    self.trailing = horizontal
  }

  /// Initializes a new `Paddings` instance with the same padding value applied to all edges.
  ///
  /// - Parameter padding: The uniform padding value for the top, leading, bottom, and trailing edges.
  public init(padding: CGFloat) {
    self.top = padding
    self.leading = padding
    self.bottom = padding
    self.trailing = padding
  }
}

// MARK: - SwiftUI Helpers

extension Paddings {
  public var edgeInsets: EdgeInsets {
    return EdgeInsets(
      top: self.top,
      leading: self.leading,
      bottom: self.bottom,
      trailing: self.trailing
    )
  }
}

// MARK: - UIKit Helpers

extension Paddings {
  public var uiEdgeInsets: UIEdgeInsets {
    return UIEdgeInsets(
      top: self.top,
      left: self.leading,
      bottom: self.bottom,
      right: self.trailing
    )
  }
}
