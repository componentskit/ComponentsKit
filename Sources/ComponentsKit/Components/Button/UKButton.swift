import AutoLayout
import UIKit

/// A UIKit component that performs an action when it is tapped by a user.
open class UKButton: FullWidthComponent, UKComponent {
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
      UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseOut]) {
        self.transform = self.isPressed && self.model.isInteractive
        ? .init(
          scaleX: self.model.animationScale.value,
          y: self.model.animationScale.value
        )
        : .identity
      }
    }
  }

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()

  /// A loading indicator shown when the button is in a loading state.
  public let loaderView = UKLoading()

  /// A stack view that manages the layout of the button’s internal content.
  private let stackView = UIStackView()

  /// An optional image displayed alongside the title.
  public let imageView = UIImageView()

  // MARK: Private Properties

  private var imageViewConstraints = LayoutConstraints()

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
    model: ButtonVM,
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
    self.addSubview(self.stackView)

    self.stackView.addArrangedSubview(self.loaderView)
    self.stackView.addArrangedSubview(self.titleLabel)
    switch self.model.imageLocation {
    case .leading:
      self.stackView.insertArrangedSubview(self.imageView, at: 0)
    case .trailing:
      self.stackView.addArrangedSubview(self.imageView)
    }

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
    Self.Style.configureStackView(self.stackView, model: self.model)
    Self.Style.loaderView(self.loaderView, model: self.model)
    Self.Style.imageView(self.imageView, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.stackView.center()

    self.imageViewConstraints = self.imageView.size(
      width: self.model.imageSide,
      height: self.model.imageSide
    )
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: ButtonVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldUpdateImagePosition(oldModel) {
      self.stackView.removeArrangedSubview(self.imageView)
      switch self.model.imageLocation {
      case .leading:
        self.stackView.insertArrangedSubview(self.imageView, at: 0)
      case .trailing:
        self.stackView.addArrangedSubview(self.imageView)
      }
    }

    if self.model.shouldUpdateImageSize(oldModel) {
      self.imageViewConstraints.width?.constant = self.model.imageSide
      self.imageViewConstraints.height?.constant = self.model.imageSide

      UIView.performWithoutAnimation {
        self.layoutIfNeeded()
      }
    }

    if self.model.shouldRecalculateSize(oldModel) {
      self.invalidateIntrinsicContentSize()
    }
  }

  // MARK: UIView methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let contentSize = self.stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
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

    if self.model.isInteractive,
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

    if self.model.isInteractive,
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
      view.layer.cornerRadius = model.cornerRadius.value(
        for: view.bounds.height
      )
    }
    static func titleLabel(_ label: UILabel, model: Model) {
      label.textAlignment = .center
      label.text = model.title
      label.font = model.preferredFont.uiFont
      label.textColor = model.foregroundColor.uiColor
      label.isHidden = model.title.isEmpty
    }
    static func configureStackView(
      _ stackView: UIStackView,
      model: Model
    ) {
      stackView.spacing = model.contentSpacing
      stackView.axis = .horizontal
      stackView.alignment = .center
      stackView.spacing = model.contentSpacing
    }
    static func loaderView(_ view: UKLoading, model: Model) {
      view.model = model.preferredLoadingVM
      view.isVisible = model.isLoading
    }
    static func imageView(_ imageView: UIImageView, model: Model) {
      imageView.image = model.imageWithLegacyFallback?.uiImage
      imageView.contentMode = .scaleAspectFit
      imageView.isHidden = model.isImageHidden
      imageView.tintColor = model.foregroundColor.uiColor
      imageView.isUserInteractionEnabled = true
    }
  }
}
