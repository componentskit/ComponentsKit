import Foundation

/// Defines the image source options for a button.
extension ButtonVM {
  public enum ImageSource: Hashable {
    /// An image loaded from a system SF Symbol.
    ///
    /// - Parameter name: The name of the SF Symbol.
    case sfSymbol(String)

    /// An image loaded from a local asset.
    ///
    /// - Parameters:
    ///   - name: The name of the local image asset.
    ///   - bundle: The bundle containing the image resource. Defaults to `nil` to use the main bundle.
    case local(String, bundle: Bundle? = nil)
  }
}
