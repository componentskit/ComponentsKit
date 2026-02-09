import SwiftUI
import UIKit

/// A lightweight, platform-agnostic container for image sources.
///
/// UniversalImage abstracts how an image is specified without committing
/// to a particular rendering type (e.g., `UIImage` on UIKit or `Image` on SwiftUI).
/// It supports two kinds of sources:
/// - SF Symbols by name
/// - Asset catalog images by name (optionally scoping lookup to a specific bundle)
///
/// This type is intended to be carried in view models and resolved into
/// platform-specific images by higher-level helpers or components.
public struct UniversalImage: Hashable {
  /// Internal representation of the image source.
  private enum ImageRepresentable: Hashable {
    /// An SF Symbol identified by its system name.
    case sfSymbol(String)
    /// An asset catalog image identified by name and an optional bundle.
    case asset(String, Bundle?)
  }

  /// The underlying image source.
  private let internalImage: ImageRepresentable
  /// Indicates how images are rendered.
  private var renderingMode: ImageRenderingMode?

  /// Creates a new instance with provided image and mode.
  private init(image: ImageRepresentable, mode: ImageRenderingMode) {
    self.internalImage = image
    self.renderingMode = mode
  }

  /// Creates an image that references an SF Symbol.
  ///
  /// - Parameter sfSymbol: The system symbol name, such as `"star.fill"`.
  ///
  /// Notes:
  /// - Availability and appearance vary by platform and OS version.
  /// - Rendering mode and weight should be applied when converting to a platform image.
  public init(systemName name: String) {
    self.internalImage = .sfSymbol(name)
  }

  /// Creates an image that references an asset catalog image.
  ///
  /// - Parameters:
  ///   - name: The asset name.
  ///   - bundle: The bundle to search. Pass `nil` to search the main bundle.
  ///
  /// Use this when your image is stored in an asset catalog. If you are distributing
  /// a framework or Swift package, provide the bundle that contains the asset.
  public init(_ name: String, bundle: Bundle? = nil) {
    self.internalImage = .asset(name, bundle)
  }
}

// MARK: - Helpers

extension UniversalImage {
  /// Resolves the universal image into a UIKit `UIImage`.
  public var uiImage: UIImage? {
    let image = switch self.internalImage {
    case .sfSymbol(let name):
      UIImage(systemName: name)
    case .asset(let name, let bundle):
      UIImage(named: name, in: bundle, with: nil)
    }
    if let renderingMode {
      return image?.withRenderingMode(renderingMode.uiImageRenderingMode)
    } else {
      return image
    }
  }

  /// Resolves the universal image into a SwiftUI `Image`.
  public var image: Image {
    let image = switch self.internalImage {
    case .sfSymbol(let name):
      Image(systemName: name)
    case .asset(let name, let bundle):
      Image(name, bundle: bundle)
    }
    if let renderingMode {
      return image.renderingMode(renderingMode.imageRenderingModel)
    } else {
      return image
    }
  }

  /// Returns a new version of the image that uses the specified rendering mode.
  public func withRenderingMode(_ mode: ImageRenderingMode) -> Self {
    return Self(image: self.internalImage, mode: mode)
  }
}
