import UIKit

/// A UIKit component that displays a profile picture, initials or fallback icon for a user.
open class UKAvatar: UIImageView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: AvatarVM {
    didSet {
      self.update(oldValue)
    }
  }

  private var loadedImage: (url: URL, image: UIImage)?

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initializers

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: AvatarVM = .init()) {
    self.model = model

    super.init(frame: .zero)

    self.style()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Style

  private func style() {
    self.contentMode = .scaleToFill
    self.clipsToBounds = true
  }

  // MARK: - Update

  public func update(_ oldModel: AvatarVM) {
    guard self.model != oldModel else { return }

    if self.model.shouldUpdateImage(oldModel) {
      self.updateImage()
    }
    if self.model.cornerRadius != oldModel.cornerRadius {
      self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
    }
    if self.model.size != oldModel.size {
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  // MARK: - Layout

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)

    self.updateImage()
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let minProvidedSide = min(size.width, size.height)
    let minPreferredSide = min(self.model.preferredSize.width, self.model.preferredSize.height)
    let side = min(minProvidedSide, minPreferredSide)
    return CGSize(width: side, height: side)
  }

  // MARK: - Helpers

  private func downloadImage(url: URL) {
    self.loadedImage = nil
    Task { @MainActor in
      guard let image = await ImageLoader.download(url: url),
            url == self.model.imageURL
      else { return }

      self.loadedImage = (url, image)
      UIView.transition(
        with: self,
        duration: 0.2,
        options: .transitionCrossDissolve,
        animations: {
          self.image = image
        }
      )
    }
  }

  private func updateImage() {
    let size = self.bounds.size
    switch self.model.imageSrc {
    case .remote(let url):
      if let loadedImage, loadedImage.url == url {
        self.image = loadedImage.image
      } else {
        self.image = self.model.placeholderImage(for: size)
        self.downloadImage(url: url)
      }
    case let .local(name, bundle):
      self.image = UIImage(named: name, in: bundle, compatibleWith: nil) ?? self.model.placeholderImage(for: size)
    case .none:
      self.image = self.model.placeholderImage(for: size)
    }
  }
}
