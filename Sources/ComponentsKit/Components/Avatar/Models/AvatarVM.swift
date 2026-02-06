import UIKit

/// A model that defines the appearance properties for an avatar component.
public struct AvatarVM: ComponentVM, Hashable {
  /// The color of the placeholder.
  public var color: ComponentColor?

  /// The corner radius of the avatar.
  ///
  /// Defaults to `.full`.
  public var cornerRadius: ComponentRadius = .full

  /// The source of the image to be displayed.
  public var imageSrc: ImageSource?

  /// The placeholder that is displayed if the image is not provided or fails to load.
  public var placeholder: Placeholder = .image(.init("avatar_placeholder", bundle: .module))

  /// The predefined size of the avatar.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `AvatarVM` with default values.
  public init() {}
}

// MARK: - Helpers

extension AvatarVM {
  var preferredSize: CGSize {
    switch self.size {
    case .small:
      return .init(width: 36, height: 36)
    case .medium:
      return .init(width: 48, height: 48)
    case .large:
      return .init(width: 64, height: 64)
    }
  }

  var imageURL: URL? {
    switch self.imageSrc {
    case .remote(let url):
      return url
    case .local, .none:
      return nil
    }
  }
}

extension AvatarVM {
  func placeholderImage(for size: CGSize) -> UIImage {
    switch self.placeholder {
    case .text(let value):
      return self.drawName(value, size: size)
    case .image(let image):
      return self.drawIcon(image.uiImage, size: size)
    }
  }

  private var placeholderFont: UIFont {
    switch self.size {
    case .small:
      return UniversalFont.smButton.uiFont
    case .medium:
      return UniversalFont.mdButton.uiFont
    case .large:
      return UniversalFont.lgButton.uiFont
    }
  }

  private func iconSize(for avatarSize: CGSize) -> CGSize {
    let minSide = min(avatarSize.width, avatarSize.height)
    let iconSize = minSide / 3 * 2
    return .init(width: iconSize, height: iconSize)
  }

  private var placeholderBackgroundColor: UIColor {
    return (self.color?.background ?? .content1).uiColor
  }

  private var placeholderForegroundColor: UIColor {
    return (self.color?.main ?? .foreground).uiColor
  }

  private func drawIcon(_ icon: UIImage?, size: CGSize) -> UIImage {
    let iconSize = self.iconSize(for: size)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      self.placeholderBackgroundColor.setFill()
      UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()

      icon?.withTintColor(self.placeholderForegroundColor).draw(in: CGRect(
        x: (size.width - iconSize.width) / 2,
        y: (size.height - iconSize.height) / 2,
        width: iconSize.width,
        height: iconSize.height
      ))
    }
  }

  private func drawName(_ name: String, size: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      self.placeholderBackgroundColor.setFill()
      UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()

      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center

      let attributes = [
        NSAttributedString.Key.font: self.placeholderFont,
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.foregroundColor: self.placeholderForegroundColor
      ]

      let yOffset = (size.height - self.placeholderFont.lineHeight) / 2
      String(name.prefix(3)).draw(
        with: CGRect(x: 0, y: yOffset, width: size.width, height: size.height),
        options: .usesLineFragmentOrigin,
        attributes: attributes,
        context: nil
      )
    }
  }
}
