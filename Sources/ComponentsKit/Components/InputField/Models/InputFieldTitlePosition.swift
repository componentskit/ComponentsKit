import Foundation

extension InputFieldVM {
  /// Specifies the position of the title relative to the input field.
  public enum TitlePosition: Sendable {
    /// The title is displayed inside the input field.
    case inside
    /// The title is displayed above the input field.
    case outside
  }
}
