import Foundation

/// The appearance style of inputs.
public enum InputStyle: Hashable, Sendable {
  /// An input with a partially transparent background.
  case light
  /// An input with a transparent background and a border.
  case bordered
  /// An input with a partially transparent background and a border.
  case faded
}
