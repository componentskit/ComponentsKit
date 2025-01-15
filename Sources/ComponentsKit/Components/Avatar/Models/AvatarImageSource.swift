import Foundation

/// Defines the source options for an avatar image.
extension AvatarVM {
  public enum ImageSource: Hashable {
    /// An image loaded from a remote URL.
    ///
    /// - Parameter url: The URL pointing to the remote image resource.
    /// - Note: Ensure the URL is valid and accessible to prevent errors during image fetching.
    case remote(_ url: URL)

    /// An image loaded from a local asset.
    ///
    /// - Parameters:
    ///   - name: The name of the local image asset.
    ///   - bundle: The bundle containing the image resource. Defaults to `nil`, which uses the main bundle.
    case local(_ name: String, _ bundle: Bundle? = nil)
  }
}
