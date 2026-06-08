@preconcurrency import Combine
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

  private let imageManager: AvatarImageManager
  private var cancellable: AnyCancellable?

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.model.preferredSize
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: AvatarVM) {
    self.model = model
    self.imageManager = AvatarImageManager(model: model)

    super.init(frame: .zero)

    self.setup()
    self.style()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Deinitialization

  deinit {
    self.cancellable?.cancel()
    self.cancellable = nil
  }

  // MARK: - Setup

  private func setup() {
    self.cancellable = self.imageManager.$avatarImage
      .receive(on: DispatchQueue.main)
      .sink { self.image = $0 }

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  // MARK: - Style

  private func style() {
    self.contentMode = .scaleToFill
    self.clipsToBounds = true
  }

  // MARK: - Update

  public func update(_ oldModel: AvatarVM) {
    guard self.model != oldModel else { return }

    self.imageManager.update(model: self.model, size: self.bounds.size)

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

    self.imageManager.update(model: self.model, size: self.bounds.size)
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let minProvidedSide = min(size.width, size.height)
    let minPreferredSide = min(self.model.preferredSize.width, self.model.preferredSize.height)
    let side = min(minProvidedSide, minPreferredSide)
    return CGSize(width: side, height: side)
  }

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: Helpers

  @objc private func handleTraitChanges() {
    self.imageManager.update(model: self.model, size: self.bounds.size)
  }
}
