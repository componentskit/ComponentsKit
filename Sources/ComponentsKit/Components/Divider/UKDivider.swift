import UIKit

/// A UIKit component that displays a separating line.
open class UKDivider: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: DividerVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initializers

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: DividerVM = .init()) {
    self.model = model
    super.init(frame: .zero)
    self.style()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Style

  private func style() {
    self.backgroundColor = self.model.lineColor.uiColor
    self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    self.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
  }

  // MARK: - Update

  public func update(_ oldModel: DividerVM) {
    guard self.model != oldModel else { return }

    self.backgroundColor = self.model.lineColor.uiColor

    if self.model.shouldUpdateLayout(oldModel) {
      self.invalidateIntrinsicContentSize()
    }
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let lineSize = self.model.lineSize
    switch self.model.orientation {
    case .vertical:
      return CGSize(width: lineSize, height: size.height)
    case .horizontal:
      return CGSize(width: size.width, height: lineSize)
    }
  }
}
