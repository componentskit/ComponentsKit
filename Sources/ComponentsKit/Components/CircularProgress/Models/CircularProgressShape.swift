import Foundation

extension CircularProgressVM {
  /// Defines the shapes for the circular progress component.
  public enum Shape: Sendable {
    /// Renders a complete circle to represent the progress.
    case circle
    /// Renders only a portion of the circle (an arc) to represent progress.
    case arc
  }
}
