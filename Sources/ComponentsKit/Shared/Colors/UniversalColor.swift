import SwiftUI
import UIKit

/// A structure that represents an universal color that can be used in both UIKit and SwiftUI,
/// with light and dark theme variants.
public struct UniversalColor: Hashable {
  // MARK: - ColorRepresentable

  /// An enumeration that defines the possible representations of a color.
  public enum ColorRepresentable: Hashable {
    /// A color defined by its RGBA components.
    ///
    /// - Parameters:
    ///   - r: The red component (0–255).
    ///   - g: The green component (0–255).
    ///   - b: The blue component (0–255).
    ///   - a: The alpha (opacity) component (0.0–1.0).
    case rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)

    /// A color represented by a `UIColor` instance.
    case uiColor(UIColor)

    /// A color represented by a SwiftUI `Color` instance.
    case color(Color)

    /// Creates a `ColorRepresentable` instance from a hexadecimal string.
    ///
    /// - Parameter value: A hex string representing the color (e.g., `"#FFFFFF"` or `"FFFFFF"`).
    /// - Returns: A `ColorRepresentable` instance with the corresponding RGBA values.
    /// - Note: This method assumes the input string has exactly six hexadecimal characters.
    /// - Warning: This method will trigger an assertion failure if the input is invalid.
    public static func hex(_ value: String) -> Self {
      let start: String.Index
      if value.hasPrefix("#") {
        start = value.index(value.startIndex, offsetBy: 1)
      } else {
        start = value.startIndex
      }

      let hexColor = String(value[start...])
      let scanner = Scanner(string: hexColor)
      var hexNumber: UInt64 = 0

      if hexColor.count == 6 && scanner.scanHexInt64(&hexNumber) {
        let r = CGFloat((hexNumber & 0x00ff0000) >> 16)
        let g = CGFloat((hexNumber & 0x0000ff00) >> 8)
        let b = CGFloat(hexNumber & 0x000000ff)

        return .rgba(r: r, g: g, b: b, a: 1.0)
      } else {
        assertionFailure(
          "Unable to initialize color from the provided hex value: \(value)"
        )
        return .rgba(r: 0, g: 0, b: 0, a: 1.0)
      }
    }

    /// Returns a new `ColorRepresentable` with the specified opacity.
    ///
    /// - Parameter alpha: The desired opacity (0.0–1.0).
    /// - Returns: A `ColorRepresentable` instance with the adjusted opacity.
    fileprivate func withOpacity(_ alpha: CGFloat) -> Self {
      switch self {
      case .rgba(let r, let g, let b, _):
        return .rgba(r: r, g: g, b: b, a: alpha)
      case .uiColor(let uiColor):
        return .uiColor(uiColor.withAlphaComponent(alpha))
      case .color(let color):
        return .color(color.opacity(alpha))
      }
    }

    /// Converts the `ColorRepresentable` to a `UIColor` instance.
    fileprivate var uiColor: UIColor {
      switch self {
      case .rgba(let red, let green, let blue, let alpha):
        return UIColor(
          red: red / 255,
          green: green / 255,
          blue: blue / 255,
          alpha: alpha
        )
      case .uiColor(let uiColor):
        return uiColor
      case .color(let color):
        return UIColor(color)
      }
    }

    /// Returns a tuple containing the red, green, blue, and alpha components of the color.
    private var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
      switch self {
      case let .rgba(r, g, b, a):
        return (r, g, b, a)
      case .uiColor, .color:
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        self.uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red * 255, green * 255, blue * 255, alpha)
      }
    }

    /// Returns a new `ColorRepresentable` by blending the current color with another color.
    ///
    /// The blending is performed using the alpha value of the current color,
    /// where the second color is treated as fully opaque (alpha = `1.0 - self.alpha`).
    ///
    /// The resulting color's RGBA components are calculated as:
    /// - `red = self.red * self.alpha + other.red * (1.0 - self.alpha)`
    /// - `green = self.green * self.alpha + other.green * (1.0 - self.alpha)`
    /// - `blue = self.blue * self.alpha + other.blue * (1.0 - self.alpha)`
    /// - The resulting color's alpha will always be `1.0`.
    ///
    /// - Parameter other: The `ColorRepresentable` to blend with the current color.
    /// - Returns: A new `ColorRepresentable` instance representing the blended color.
    fileprivate func blended(with other: Self) -> Self {
      let rgba = self.rgba
      let otherRgba = other.rgba

      let red = rgba.r * rgba.a + otherRgba.r * (1.0 - rgba.a)
      let green = rgba.g * rgba.a + otherRgba.g * (1.0 - rgba.a)
      let blue = rgba.b * rgba.a + otherRgba.b * (1.0 - rgba.a)

      return .rgba(r: red, g: green, b: blue, a: 1.0)
    }
  }

  // MARK: - Properties

  /// The color used in light mode.
  let light: ColorRepresentable

  /// The color used in dark mode.
  let dark: ColorRepresentable

  // MARK: - Initialization

  /// Creates a `UniversalColor` with distinct light and dark mode colors.
  ///
  /// - Parameters:
  ///   - light: The color to use in light mode.
  ///   - dark: The color to use in dark mode.
  /// - Returns: A new `UniversalColor` instance.
  public static func themed(
    light: ColorRepresentable,
    dark: ColorRepresentable
  ) -> Self {
    return Self(light: light, dark: dark)
  }

  /// Creates a `UniversalColor` with a single color used for both light and dark modes.
  ///
  /// - Parameter universal: The universal color to use.
  /// - Returns: A new `UniversalColor` instance.
  public static func universal(_ universal: ColorRepresentable) -> Self {
    return Self(light: universal, dark: universal)
  }

  // MARK: - Colors

  /// Returns the `UIColor` representation of the color.
  public var uiColor: UIColor {
    return UIColor { trait in
      switch trait.userInterfaceStyle {
      case.light:
        return self.light.uiColor
      case .dark:
        return self.dark.uiColor
      default:
        return self.light.uiColor
      }
    }
  }

  /// Returns the `Color` representation of the color.
  public var color: Color {
    return Color(self.uiColor)
  }

  /// Returns the `CGColor` representation of the color.
  public var cgColor: CGColor {
    return self.uiColor.cgColor
  }

  // MARK: - Methods

  /// Returns a new `UniversalColor` with the specified opacity.
  ///
  /// - Parameter alpha: The desired opacity (0.0–1.0).
  /// - Returns: A new `UniversalColor` instance with the adjusted opacity.
  public func withOpacity(_ alpha: CGFloat) -> Self {
    return .init(
      light: self.light.withOpacity(alpha),
      dark: self.dark.withOpacity(alpha)
    )
  }

  /// Returns a disabled version of the color based on a global opacity configuration.
  ///
  /// - Parameter isEnabled: A Boolean value indicating whether the color should be enabled.
  /// - Returns: A new `UniversalColor` instance with reduced opacity if `isEnabled` is `false`.
  public func enabled(_ isEnabled: Bool) -> Self {
    return isEnabled
    ? self
    : self.withOpacity(Theme.current.layout.disabledOpacity)
  }

  /// Returns a new `UniversalColor` by blending the current color with another color.
  ///
  /// The blending is performed using the alpha value of the current color,
  /// where the second color is treated as fully opaque (alpha = `1.0 - self.alpha`).
  ///
  /// The resulting color's RGBA components are calculated as:
  /// - `red = self.red * self.alpha + other.red * (1.0 - self.alpha)`
  /// - `green = self.green * self.alpha + other.green * (1.0 - self.alpha)`
  /// - `blue = self.blue * self.alpha + other.blue * (1.0 - self.alpha)`
  /// - The resulting color's alpha will always be `1.0`.
  ///
  /// - Parameter other: The `UniversalColor` to blend with the current color.
  /// - Returns: A new `UniversalColor` instance representing the blended color.
  public func blended(with other: Self) -> Self {
    return .init(
      light: self.light.blended(with: other.light),
      dark: self.dark.blended(with: other.dark)
    )
  }
}
