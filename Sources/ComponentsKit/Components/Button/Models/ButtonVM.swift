import UIKit

/// A model that defines the appearance properties for a button component.
public struct ButtonVM: ComponentVM {
  /// The scaling factor for the button's press animation, with a value between 0 and 1.
  ///
  /// Defaults to `.medium`.
  public var animationScale: AnimationScale = .medium

  /// The color of the button.
  public var color: ComponentColor?

  /// The spacing between the button's title and its image or loading indicator.
  ///
  /// Defaults to `8.0`.
  public var contentSpacing: CGFloat = 8.0

  /// The corner radius of the button.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the button's title text.
  ///
  /// If not provided, the font is automatically calculated based on the button's size.
  public var font: UniversalFont?

  /// The image to be displayed.
  public var image: UniversalImage?

  /// The position of the image relative to the button's title.
  ///
  /// Defaults to `.leading`.
  public var imageLocation: ImageLocation = .leading

  /// Defines how image is rendered.
  @available(*, deprecated, message: "Use `image.withRenderingMode(_:)` instead.")
  public var imageRenderingMode: ImageRenderingMode?

  /// The source of the image to be displayed.
  @available(*, deprecated, message: "Use `image` instead.")
  public var imageSrc: ImageSource?

  /// A Boolean value indicating whether the button is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// A Boolean value indicating whether the button should occupy the full width of its superview.
  ///
  /// Defaults to `false`.
  public var isFullWidth: Bool = false

  /// A Boolean value indicating whether the button is currently in a loading state.
  ///
  /// Defaults to `false`.
  public var isLoading: Bool = false

  /// The loading VM used for the loading indicator.
  ///
  /// If not provided, a default loading view model is used.
  public var loadingVM: LoadingVM?

  /// The predefined size of the button.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The visual style of the button.
  ///
  /// Defaults to `.filled`.
  public var style: ButtonStyle = .filled

  /// The text displayed on the button.
  public var title: String = ""

  /// Initializes a new instance of `ButtonVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension ButtonVM {
  var isInteractive: Bool {
    self.isEnabled && !self.isLoading
  }
  var preferredLoadingVM: LoadingVM {
    return self.loadingVM ?? .init {
      $0.color = .init(
        main: foregroundColor,
        contrast: self.color?.main ?? .background
      )
      $0.size = .small
    }
  }
  var backgroundColor: UniversalColor? {
    switch self.style {
    case .filled:
      let color = self.color?.main ?? .content2
      return color.enabled(self.isInteractive)
    case .light:
      let color = self.color?.background ?? .content1
      return color.enabled(self.isInteractive)
    case .plain, .bordered, .minimal:
      return nil
    }
  }
  var foregroundColor: UniversalColor {
    let color = switch self.style {
    case .filled:
      self.color?.contrast ?? .foreground
    case .plain, .light, .bordered, .minimal:
      self.color?.main ?? .foreground
    }
    return color.enabled(self.isInteractive)
  }
  var borderWidth: CGFloat {
    switch self.style {
    case .filled, .plain, .light, .minimal:
      return 0.0
    case .bordered(let borderWidth):
      return borderWidth.value
    }
  }
  var borderColor: UniversalColor? {
    switch self.style {
    case .filled, .plain, .light, .minimal:
      return nil
    case .bordered:
      if let color {
        return color.main.enabled(self.isInteractive)
      } else {
        return .divider
      }
    }
  }
  var preferredFont: UniversalFont {
    if let font {
      return font
    }

    switch self.size {
    case .small:
      return .smButton
    case .medium:
      return .mdButton
    case .large:
      return .lgButton
    }
  }
  var height: CGFloat? {
    switch self.style {
    case .minimal:
      return nil
    case .light, .filled, .bordered, .plain:
      return switch self.size {
      case .small: 36
      case .medium: 44
      case .large: 52
      }
    }
  }
  var imageSide: CGFloat {
    switch self.size {
    case .small: 20
    case .medium: 24
    case .large: 28
    }
  }
  var horizontalPadding: CGFloat {
    switch self.style {
    case .minimal:
      return 0
    case .light, .filled, .bordered, .plain:
      if self.title.isNotEmpty || self.isLoading {
        return switch self.size {
        case .small: 16
        case .medium: 20
        case .large: 24
        }
      } else {
        return switch self.size {
        case .small: 8
        case .medium: 10
        case .large: 12
        }
      }
    }
  }
  var imageWithLegacyFallback: UniversalImage? {
    if let image { return image }

    guard let imageSrc else { return nil }

    let image = switch imageSrc {
    case .sfSymbol(let name):
      UniversalImage(systemName: name)
    case .local(let name, let bundle):
      UniversalImage(name, bundle: bundle)
    }
    if let imageRenderingMode {
      return image.withRenderingMode(imageRenderingMode)
    } else {
      return image
    }
  }
}

// MARK: UIKit Helpers

extension ButtonVM {
  var isImageHidden: Bool {
    return self.isLoading || self.imageWithLegacyFallback.isNil
  }
  func preferredSize(
    for contentSize: CGSize,
    parentWidth: CGFloat?
  ) -> CGSize {
    let width: CGFloat
    if self.isFullWidth {
      if let parentWidth, parentWidth > 0 {
        width = parentWidth
      } else {
        width = 10_000
      }
    } else {
      width = contentSize.width + 2 * self.horizontalPadding
    }

    return .init(width: width, height: self.height ?? contentSize.height)
  }
  func shouldUpdateImagePosition(_ oldModel: Self?) -> Bool {
    guard let oldModel else { return true }
    return self.imageLocation != oldModel.imageLocation
  }
  func shouldUpdateImageSize(_ oldModel: Self?) -> Bool {
    guard let oldModel else { return true }
    return self.imageSide != oldModel.imageSide
  }
  func shouldRecalculateSize(_ oldModel: Self?) -> Bool {
    guard let oldModel else { return true }
    return self.size != oldModel.size
    || self.font != oldModel.font
    || self.isFullWidth != oldModel.isFullWidth
    || self.isLoading != oldModel.isLoading
    || self.imageWithLegacyFallback != oldModel.imageWithLegacyFallback
    || self.contentSpacing != oldModel.contentSpacing
    || self.title != oldModel.title
  }
}

// MARK: SwiftUI Helpers

extension ButtonVM {
  var width: CGFloat? {
    return self.isFullWidth ? 10_000 : nil
  }
}
