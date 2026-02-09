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

    /// A placeholder that displays an SF Symbol.
    @available(*, deprecated, message: "Use `image(_:)` instead.")
    public static func sfSymbol(_ name: String) -> Self {
      return .image(.init(systemName: name))
    }

    /// A placeholder that displays a custom icon from an asset catalog.
    @available(*, deprecated, message: "Use `image(_:)` instead.")
    public static func icon(_ name: String, _ bundle: Bundle? = nil) -> Self {
      return .image(.init(name, bundle: bundle))
    }
  }
}
