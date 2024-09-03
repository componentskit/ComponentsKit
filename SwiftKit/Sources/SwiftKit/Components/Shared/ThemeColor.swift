import SwiftUI
import UIKit

public struct ThemeColor: Equatable {
  // MARK: ColorRepresentable

  public enum ColorRepresentable: Equatable {
    case rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    case uiColor(UIColor)
    case color(Color)

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

      if hexColor.count == 8 && scanner.scanHexInt64(&hexNumber) {
        let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        let a = CGFloat(hexNumber & 0x000000ff) / 255

        return .rgba(r: r, g: g, b: b, a: a)
      } else {
        fatalError("Unable to initialize color from the provided hex value: \(value)")
      }
    }

    fileprivate func withOpacity(_ alpha: CGFloat) -> Self {
      switch self {
      case .rgba(let r, let g, let b, let a):
        return .rgba(r: r, g: g, b: b, a: a * alpha)
      case .uiColor(let uiColor):
        return .uiColor(uiColor.withAlphaComponent(alpha))
      case .color(let color):
        return .color(color.opacity(alpha))
      }
    }

    fileprivate var uiColor: UIColor {
      switch self {
      case .rgba(let red, let green, let blue, let alpha):
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
      case .uiColor(let uiColor):
        return uiColor
      case .color(let color):
        return UIColor(color)
      }
    }

    fileprivate var color: Color {
      switch self {
      case .rgba(let r, let g, let b, let a):
        return Color(red: r, green: g, blue: b, opacity: a)
      case .uiColor(let uiColor):
        return Color(uiColor: uiColor)
      case .color(let color):
        return color
      }
    }
  }

  // MARK: Properties

  public let light: ColorRepresentable
  public let dark: ColorRepresentable

  // MARK: Initialization

  public init(light: ColorRepresentable, dark: ColorRepresentable) {
    self.light = light
    self.dark = dark
  }

  public init(universal: ColorRepresentable) {
    self.light = universal
    self.dark = universal
  }

  // MARK: Methods

  public func withOpacity(_ alpha: CGFloat) -> Self {
    return .init(
      light: self.light.withOpacity(alpha),
      dark: self.dark.withOpacity(alpha)
    )
  }

  // MARK: Colors

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

  public func color(for colorScheme: ColorScheme) -> Color {
    switch colorScheme {
    case .light:
      return self.light.color
    case .dark:
      return self.dark.color
    @unknown default:
      return self.light.color
    }
  }
}
