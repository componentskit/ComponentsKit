import Foundation

/// Defines the source options for an avatar image.
extension AvatarVM {
  public enum ImageSource: Hashable, Sendable {
    /// An image loaded from a remote URL.
    ///
    /// - Parameter url: The URL pointing to the remote image resource.
    /// - Note: Ensure the URL is valid and accessible to prevent errors during image fetching.
    case remote(_ url: URL)

    /// An image referenced locally using a `UniversalImage`.
    ///
    /// - Parameter image: See ``UniversalImage``.
    case local(_ image: UniversalImage)
  }
}
