import AutoLayout
import UIKit

/// A UIKit component that serves as a container for provided content.
///
/// - Example:
/// ```swift
/// let banner = UKCard(
///   model: .init(),
///   content: {
///     let label = UILabel()
///     label.text = "This is the content of the card."
///     label.numberOfLines = 0
///     return label
///   }
/// )
/// ```
open class UKCard<Content: UIView>: UIView, UKComponent {
  // MARK: - Subviews

  /// The primary content of the card, provided as a custom view.
  public let content: Content

  // MARK: - Properties

  private var contentConstraints = LayoutConstraints()

  /// A model that defines the appearance properties.
  public var model: CardVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - content: The content that is displayed in the card.
  public init(
    model: CardVM = .init(),
    content: @escaping () -> Content
  ) {
    self.model = model
    self.content = content()

    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  /// Sets up the card's subviews.
  open func setup() {
    self.addSubview(self.content)

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  // MARK: - Style

  /// Applies styling to the card's subviews.
  open func style() {
    Self.Style.mainView(self, model: self.model)
  }

  // MARK: - Layout

  /// Configures the layout.
  open func layout() {
    self.contentConstraints = LayoutConstraints.merged {
      self.content.top(self.model.contentPaddings.top)
      self.content.bottom(self.model.contentPaddings.bottom)
      self.content.leading(self.model.contentPaddings.leading)
      self.content.trailing(self.model.contentPaddings.trailing)
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
  }

  /// Updates appearance when the model changes.
  open func update(_ oldValue: CardVM) {
    guard self.model != oldValue else { return }

    self.style()

    if self.model.contentPaddings != oldValue.contentPaddings {
      self.contentConstraints.top?.constant = self.model.contentPaddings.top
      self.contentConstraints.bottom?.constant = -self.model.contentPaddings.bottom
      self.contentConstraints.leading?.constant = self.model.contentPaddings.leading
      self.contentConstraints.trailing?.constant = -self.model.contentPaddings.trailing

      self.layoutIfNeeded()
    }
  }

  // MARK: - UIView Methods

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: - Helpers

  @objc private func handleTraitChanges() {
    Self.Style.mainView(self, model: self.model)
  }
}

extension UKCard {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: Model) {
      view.backgroundColor = model.preferredBackgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value
      view.layer.borderWidth = model.borderWidth.value
      view.layer.borderColor = UniversalColor.divider.cgColor
      view.shadow(model.shadow)
    }
  }
}
