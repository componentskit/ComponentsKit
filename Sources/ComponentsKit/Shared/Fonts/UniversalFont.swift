import SwiftUI
import UIKit

/// A structure that represents an universal font that can be used in both UIKit and SwiftUI,
/// with support for custom and system fonts.
public enum UniversalFont: Hashable {
  /// An enumeration that defines the weight of a font.
  public enum Weight: Hashable {
    /// Ultra-light font weight.
    case ultraLight
    /// Thin font weight.
    case thin
    /// Light font weight.
    case light
    /// Regular font weight.
    case regular
    /// Medium font weight.
    case medium
    /// Semi-bold font weight.
    case semibold
    /// Bold font weight.
    case bold
    /// Heavy font weight.
    case heavy
    /// Black (extra-bold) font weight.
    case black
  }

  /// A custom font with a specific name and size.
  ///
  /// - Parameters:
  ///   - name: The name of the font.
  ///   - size: The size of the font.
  case custom(name: String, size: CGFloat)

  /// A system font with a specific size and weight.
  ///
  /// - Parameters:
  ///   - size: The size of the font.
  ///   - weight: The weight of the font, defined by `UniversalFont.Weight`.
  case system(size: CGFloat, weight: Weight)

  // MARK: Fonts

  /// Converts the `UniversalFont` to a `UIFont` instance.
  ///
  /// - Returns: A `UIFont` representation of the `UniversalFont`.
  public var uiFont: UIFont {
    switch self {
    case .custom(let name, let size):
      guard let font = UIFont(name: name, size: size) else {
        assertionFailure("Unable to initialize font '\(name)'")
        return UIFont.systemFont(ofSize: size)
      }
      return font
    case let .system(size, weight):
      return UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight)
    }
  }

  /// Converts the `UniversalFont` to a SwiftUI `Font` instance.
  ///
  /// - Returns: A `Font` representation of the `UniversalFont`.
  public var font: Font {
    switch self {
    case .custom(let name, let size):
      return Font.custom(name, size: size)
    case .system(let size, let weight):
      return Font.system(size: size, weight: weight.swiftUIFontWeight)
    }
  }

  // MARK: Helpers

  /// Returns a new `UniversalFont` with the specified size.
  ///
  /// - Parameter size: The new size for the font.
  /// - Returns: A new `UniversalFont` instance with the updated size.
  public func withSize(_ size: CGFloat) -> Self {
    switch self {
    case .custom(let name, _):
      return .custom(name: name, size: size)
    case .system(_, let weight):
      return .system(size: size, weight: weight)
    }
  }

  /// Returns a new `UniversalFont` with a size adjusted by a relative value.
  ///
  /// - Parameter shift: The amount to adjust the font size by.
  /// - Returns: A new `UniversalFont` instance with the adjusted size.
  public func withRelativeSize(_ shift: CGFloat) -> Self {
    switch self {
    case .custom(let name, let size):
      return .custom(name: name, size: size + shift)
    case .system(let size, let weight):
      return .system(size: size + shift, weight: weight)
    }
  }
}

// MARK: Helpers

extension UniversalFont.Weight {
  /// Converts `UniversalFont.Weight` to `UIFont.Weight`.
  var uiFontWeight: UIFont.Weight {
    switch self {
    case .ultraLight:
      return .ultraLight
    case .thin:
      return .thin
    case .light:
      return .light
    case .regular:
      return .regular
    case .medium:
      return .medium
    case .semibold:
      return .semibold
    case .bold:
      return .bold
    case .heavy:
      return .heavy
    case .black:
      return .black
    }
  }
}

extension UniversalFont.Weight {
  /// Converts `UniversalFont.Weight` to SwiftUI `Font.Weight`.
  var swiftUIFontWeight: Font.Weight {
    switch self {
    case .ultraLight:
      return .ultraLight
    case .thin:
      return .thin
    case .light:
      return .light
    case .regular:
      return .regular
    case .medium:
      return .medium
    case .semibold:
      return .semibold
    case .bold:
      return .bold
    case .heavy:
      return .heavy
    case .black:
      return .black
    }
  }
}

// MARK: - UniversalFont + Config

extension UniversalFont {
  /// Small headline font.
  public static var smHeadline: UniversalFont {
    return Theme.current.layout.typography.headline.small
  }
  /// Medium headline font.
  public static var mdHeadline: UniversalFont {
    return Theme.current.layout.typography.headline.medium
  }
  /// Large headline font.
  public static var lgHeadline: UniversalFont {
    return Theme.current.layout.typography.headline.large
  }

  /// Small body font.
  public static var smBody: UniversalFont {
    return Theme.current.layout.typography.body.small
  }
  /// Medium body font.
  public static var mdBody: UniversalFont {
    return Theme.current.layout.typography.body.medium
  }
  /// Large body font.
  public static var lgBody: UniversalFont {
    return Theme.current.layout.typography.body.large
  }

  /// Small button font.
  public static var smButton: UniversalFont {
    return Theme.current.layout.typography.button.small
  }
  /// Medium button font.
  public static var mdButton: UniversalFont {
    return Theme.current.layout.typography.button.medium
  }
  /// Large button font.
  public static var lgButton: UniversalFont {
    return Theme.current.layout.typography.button.large
  }

  /// Small caption font.
  public static var smCaption: UniversalFont {
    return Theme.current.layout.typography.caption.small
  }
  /// Medium caption font.
  public static var mdCaption: UniversalFont {
    return Theme.current.layout.typography.caption.medium
  }
  /// Large caption font.
  public static var lgCaption: UniversalFont {
    return Theme.current.layout.typography.caption.large
  }
}
