import AutoLayout
import UIKit

/// A UIKit component that displays a badge.
open class UKBadge: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: BadgeVM {
    didSet {
      self.update(oldValue)
    }
  }

  private var titleLabelConstraints: LayoutConstraints = .init()

  // MARK: - Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initialization

  /// Initializes a new instance of `UKBadge`.
  /// - Parameter model: A model that defines the appearance properties for the badge.
  public init(model: BadgeVM = .init()) {
    self.model = model
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setup() {
    self.addSubview(self.titleLabel)
  }

  // MARK: - Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
  }

  // MARK: - Layout

  private func layout() {
    self.titleLabelConstraints = .merged {
      self.titleLabel.top(self.model.paddings.top)
      self.titleLabel.leading(self.model.paddings.leading)
      self.titleLabel.bottom(self.model.paddings.bottom)
      self.titleLabel.trailing(self.model.paddings.trailing)
    }

    self.titleLabelConstraints.allConstraints.forEach { $0?.priority = .defaultHigh }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: - Update

  public func update(_ oldModel: BadgeVM) {
    guard self.model != oldModel else { return }

    self.style()
    if self.model.shouldUpdateLayout(oldModel) {
      self.titleLabelConstraints.leading?.constant = self.model.paddings.leading
      self.titleLabelConstraints.top?.constant = self.model.paddings.top
      self.titleLabelConstraints.bottom?.constant = -self.model.paddings.bottom
      self.titleLabelConstraints.trailing?.constant = -self.model.paddings.trailing

      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let contentSize = self.titleLabel.sizeThatFits(size)

    let totalWidthPadding = self.model.paddings.leading + self.model.paddings.trailing
    let totalHeightPadding = self.model.paddings.top + self.model.paddings.bottom

    let width = contentSize.width + totalWidthPadding
    let height = contentSize.height + totalHeightPadding

    return CGSize(
      width: min(width, size.width),
      height: min(height, size.height)
    )
  }
}

// MARK: - Style Helpers

extension UKBadge {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: BadgeVM) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value(for: view.bounds.height)
    }
    static func titleLabel(_ label: UILabel, model: BadgeVM) {
      label.textAlignment = .center
      label.text = model.title
      label.font = model.font.uiFont
      label.textColor = model.foregroundColor.uiColor
    }
  }
}
