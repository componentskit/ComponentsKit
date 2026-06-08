import Foundation

extension CountdownVM {
  /// Defines the visual styles for the countdown component.
  public enum Style: Equatable, Sendable {
    case plain
    case light
  }

  /// Defines the units style for the countdown component.
  public enum UnitsStyle: Equatable, Sendable {
    case hidden
    case bottom
    case trailing
  }
}
