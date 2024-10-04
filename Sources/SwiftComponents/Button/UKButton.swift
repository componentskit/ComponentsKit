import UIKit

/// A UIKit component that performs an action when it is tapped by a user.
open class UKButton: UIView, UKComponent {
  // MARK: Properties

  /// A closure that is triggered when the button is tapped.
  public var action: () -> Void

  /// A model that defines the appearance properties.
  public var model: ButtonVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// A Boolean value indicating whether the button is pressed.
  public private(set) var isPressed: Bool = false {
    didSet {
      self.transform = self.isPressed && self.model.isEnabled
      ? .init(
        scaleX: self.model.preferredAnimationScale.value,
        y: self.model.preferredAnimationScale.value
      )
      : .identity
    }
  }

  private var titleLabelConstraints: AnchoredConstraints = .init()

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - action: A closure that is triggered when the button is tapped.
  public init(
    model: ButtonVM = .init(),
    action: @escaping () -> Void = {}
  ) {
    self.model = model
    self.action = action
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.titleLabel)

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  // MARK: Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.titleLabelConstraints = self.titleLabel.horizontally(self.model.horizontalPadding)
    self.titleLabel.centerVertically()
    self.titleLabel.centerHorizontally()

    self.titleLabelConstraints.leading?.priority = .defaultHigh
    self.titleLabelConstraints.trailing?.priority = .defaultHigh
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.preferredCornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: ButtonVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldUpdateSize(oldModel) {
      self.titleLabelConstraints.leading?.constant = self.model.horizontalPadding
      self.titleLabelConstraints.trailing?.constant = -self.model.horizontalPadding
      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }
  }

  // MARK: UIView methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let contentSize = self.titleLabel.sizeThatFits(size)
    let preferredSize = self.model.preferredSize(
      for: contentSize,
      parentWidth: self.superview?.bounds.width
    )
    return .init(
      width: min(preferredSize.width, size.width),
      height: min(preferredSize.height, size.height)
    )
  }

  open override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesBegan(touches, with: event)

    self.isPressed = true
  }

  open override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesEnded(touches, with: event)

    defer { self.isPressed = false }

    if self.model.isEnabled,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.action()
    }
  }

  open override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesCancelled(touches, with: event)

    defer { self.isPressed = false }

    if self.model.isEnabled,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.action()
    }
  }

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: Helpers

  @objc private func handleTraitChanges() {
    self.layer.borderColor = self.model.borderColor?.uiColor.cgColor
  }
}

// MARK: - Style Helpers

extension UKButton {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: Model) {
      view.layer.borderWidth = model.borderWidth
      view.layer.borderColor = model.borderColor?.uiColor.cgColor
      view.backgroundColor = model.backgroundColor?.uiColor
      view.layer.cornerRadius = model.preferredCornerRadius.value(
        for: view.bounds.height
      )
    }
    static func titleLabel(_ label: UILabel, model: Model) {
      label.textAlignment = .center
      label.text = model.title
      label.font = model.preferredFont.uiFont
      label.textColor = model.foregroundColor.uiColor
    }
  }
}
