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

  // MARK: - Public Properties

  /// A closure that is triggered when the card is tapped.
  public var onTap: () -> Void

  /// A Boolean value indicating whether the button is pressed.
  public private(set) var isPressed: Bool = false {
    didSet {
      UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseOut]) {
        self.transform = self.isPressed
        ? .init(
          scaleX: self.model.animationScale.value,
          y: self.model.animationScale.value
        )
        : .identity
      }
    }
  }

  /// A model that defines the appearance properties.
  public var model: CardVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: - Private Properties

  private var contentConstraints = LayoutConstraints()

  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - content: The content that is displayed in the card.
  public init(
    model: CardVM = .init(),
    content: @escaping () -> Content,
    onTap: @escaping () -> Void = {}
  ) {
    self.model = model
    self.content = content()
    self.onTap = onTap

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

  // MARK: - Update

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

  open override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesBegan(touches, with: event)

    guard self.model.isTappable else { return }

    self.isPressed = true
  }

  open override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesEnded(touches, with: event)

    guard self.model.isTappable else { return }

    defer { self.isPressed = false }

    if self.model.isTappable,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.onTap()
    }
  }

  open override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesCancelled(touches, with: event)

    guard self.model.isTappable else { return }

    defer { self.isPressed = false }

    if self.model.isTappable,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.onTap()
    }
  }

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
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value
      view.layer.borderWidth = model.borderWidth.value
      view.layer.borderColor = model.borderColor.cgColor
      view.shadow(model.shadow)
    }
  }
}
