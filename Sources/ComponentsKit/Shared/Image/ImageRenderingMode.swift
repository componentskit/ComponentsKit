import SwiftUI
import UIKit

/// A type that indicates how images are rendered.
public enum ImageRenderingMode {
  /// A mode that renders all non-transparent pixels as the foreground
  /// color.
  case template
  /// A mode that renders pixels of bitmap images as-is.
  ///
  /// For system images created from the SF Symbol set, multicolor symbols
  /// respect the current foreground and accent colors.
  case original
}

// MARK: - UIKit Helpers

extension ImageRenderingMode {
  var uiImageRenderingMode: UIImage.RenderingMode {
    switch self {
    case .template:
      return .alwaysTemplate
    case .original:
      return .alwaysOriginal
    }
  }
}

// MARK: - SwiftUI Helpers

extension ImageRenderingMode {
  var imageRenderingModel: Image.TemplateRenderingMode {
    switch self {
    case .template:
      return .template
    case .original:
      return .original
    }
  }
}
