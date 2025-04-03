import AutoLayout
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
        scaleX: self.model.animationScale.value,
        y: self.model.animationScale.value
      )
      : .identity
    }
  }

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()

  /// A loader view, created with the preferred loading VM from the model.
  public let loaderView: UKLoading

  /// A stack view that arranges the loader and title label.
  private let stackView = UIStackView()

  /// A image view for displaying the image from the model.
  public let imageView: UIImageView = UIImageView()

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
    self.loaderView = UKLoading(model: model.preferredLoadingVM)
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
    Self.Style.configureStackView(
      self.stackView,
      model: self.model,
      loaderView: self.loaderView,
      titleLabel: self.titleLabel,
      imageView: self.imageView
    )

    self.loaderView.model = self.model.preferredLoadingVM

    self.loaderView.isHidden = !self.model.isLoading
  }

  // MARK: Layout

  private func layout() {
    self.stackView.center()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: ButtonVM) {
    guard self.model != oldModel else { return }

    self.style()

    self.imageView.image = self.model.uiImage
    self.imageView.tintColor = self.model.foregroundColor.uiColor

    if self.model.shouldUpdateSize(oldModel)
        || self.model.isLoading != oldModel.isLoading
        || self.model.imageSrc != oldModel.imageSrc
        || self.model.imageLocation != oldModel.imageLocation {
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

    self.isPressed = false
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
    }
    static func configureStackView(
      _ stackView: UIStackView,
      model: Model,
      loaderView: UKLoading,
      titleLabel: UILabel,
      imageView: UIImageView
    ) {
      stackView.axis = .horizontal
      stackView.alignment = .center
      stackView.spacing = model.contentSpacing

      for subview in stackView.arrangedSubviews {
        stackView.removeArrangedSubview(subview)
        subview.removeFromSuperview()
      }

      if model.isLoading {
        stackView.addArrangedSubview(loaderView)
        stackView.addArrangedSubview(titleLabel)
        return
      }

      if model.imageSrc != nil {
        switch model.imageLocation {
        case .leading:
          stackView.addArrangedSubview(imageView)
          stackView.addArrangedSubview(titleLabel)
        case .trailing:
          stackView.addArrangedSubview(titleLabel)
          stackView.addArrangedSubview(imageView)
        }
      } else {
        stackView.addArrangedSubview(titleLabel)
      }
    }
  }
}
