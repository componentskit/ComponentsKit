import Foundation

/// The buttons appearance style.
public enum ButtonStyle: Hashable, Sendable {
  /// A button with a filled background.
  case filled
  /// A button with a transparent background.
  case plain
  /// A button with a partially transparent background.
  case light
  /// A button with a transparent background and a border.
  case bordered(BorderWidth)
  /// A button with no background or padding, sized strictly to fit its content.
  case minimal
}
