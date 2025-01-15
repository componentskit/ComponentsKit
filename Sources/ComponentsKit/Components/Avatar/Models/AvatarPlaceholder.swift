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

    /// A placeholder that displays an SF Symbol.
    ///
    /// This option allows you to use Apple's system-provided icons as placeholders.
    ///
    /// - Parameter name: The name of the SF Symbol to display.
    /// - Note: Ensure that the SF Symbol name corresponds to an existing icon in the system's symbol library.
    case sfSymbol(_ name: String)

    /// A placeholder that displays a custom icon from an asset catalog.
    ///
    /// This option allows you to use icons from your app's bundled resources or a specified bundle.
    ///
    /// - Parameters:
    ///   - name: The name of the icon asset to use as the placeholder.
    ///   - bundle: The bundle containing the icon resource. Defaults to `nil`, which uses the main bundle.
    case icon(_ name: String, _ bundle: Bundle? = nil)
  }
}
