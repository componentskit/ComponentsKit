import Foundation

/// Defines the placeholder options for an avatar.
///
/// It is used to provide a fallback or alternative visual representation when an image is not provided or fails to load.
extension AvatarVM {
  public enum Placeholder: Hashable {
    /// A placeholder that displays a text string.
    ///
    /// This option is typically used to show initials, names, or other textual representations.
    ///
    /// - Parameter text: The text to display as the placeholder.
    /// - Note: Only 3 first letters are displayed.
    case text(String)

    /// A placeholder that displays an image.
    ///
    /// - Parameter image: See ``UniversalImage``.
    case image(_ image: UniversalImage)
  }
}
