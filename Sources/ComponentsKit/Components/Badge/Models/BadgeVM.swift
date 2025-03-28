import SwiftUI

/// A model that defines the appearance properties for a badge component.
public struct BadgeVM: ComponentVM {
  /// The text displayed on the badge.
  public var title: String = ""

  /// The color of the badge.
  public var color: ComponentColor?

  /// The corner radius of the badge.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the badge's text.
  ///
  /// Defaults to `.smButton`.
  public var font: UniversalFont = .smButton

  /// A Boolean value indicating whether the button is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// Paddings for the badge.
  public var paddings: Paddings = .init(horizontal: 10, vertical: 8)

  /// The visual style of the badge.
  ///
  /// Defaults to `.filled`.
  public var style: Style = .filled

  /// Initializes a new instance of `BadgeVM` with default values.
  public init() {}
}

// MARK: Helpers

extension BadgeVM {
  /// Returns the background color of the badge based on its style.
  var backgroundColor: UniversalColor {
    let color = switch self.style {
    case .filled:
      self.color?.main ?? .content2
    case .light:
      self.color?.background ?? .content1
    }
    return color.enabled(self.isEnabled)
  }

  /// Returns the foreground color of the badge based on its style.
  var foregroundColor: UniversalColor {
    let color = switch self.style {
    case .filled:
      self.color?.contrast ?? .foreground
    case .light:
      self.color?.main ?? .foreground
    }
    return color.enabled(self.isEnabled)
  }
}

// MARK: UIKit Helpers

extension BadgeVM {
  func shouldUpdateLayout(_ oldModel: Self?) -> Bool {
    return self.font != oldModel?.font
    || self.paddings != oldModel?.paddings
  }
}
