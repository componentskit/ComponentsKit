import AutoLayout
import UIKit

/// A UIKit component that displays a field to input a text.
open class UKInputField: FullWidthComponent, UKComponent {
  // MARK: Public Properties

  /// A closure that is triggered when the text changes.
  public var onValueChange: (String) -> Void

  /// A model that defines the appearance properties.
  public var model: InputFieldVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// A text inputted in the field.
  public var text: String {
    get {
      return self.textField.text ?? ""
    }
    set {
      guard newValue != self.text else { return }

      self.textField.text = newValue
      self.onValueChange(newValue)
    }
  }

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()
  /// An underlying text field from the standard library.
  public var textField = UITextField()
  /// A label that displays the caption from the model.
  public var captionLabel = UILabel()
  /// A view that contains `horizontalStackView` to have paddings.
  public var textFieldContainer = UIView()
  /// A stack view that contains `textField` and `titleLabel` when it is inside.
  public var horizontalStackView = UIStackView()
  /// A stack view that contains `textFieldContainer`, `captionLabel` and `titleLabel` when it is outside.
  public var verticalStackView = UIStackView()

  // MARK: Private Properties

  private var textFieldContainerConstraints = LayoutConstraints()
  private var horizontalStackViewConstraints = LayoutConstraints()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  open override var isFirstResponder: Bool {
    return self.textField.isFirstResponder
  }

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialText: A text that is initially inputted in the field.
  ///   - model: A model that defines the appearance properties.
  ///   - onValueChange: A closure that is triggered when the text changes.
  public init(
    initialText: String = "",
    model: InputFieldVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    self.model = model
    self.onValueChange = onValueChange
    super.init(frame: .zero)

    self.text = initialText

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.verticalStackView)
    switch self.model.titlePosition {
    case .inside:
      self.horizontalStackView.addArrangedSubview(self.titleLabel)
    case .outside:
      self.verticalStackView.addArrangedSubview(self.titleLabel)
    }
    self.verticalStackView.addArrangedSubview(self.textFieldContainer)
    self.verticalStackView.addArrangedSubview(self.captionLabel)
    self.horizontalStackView.addArrangedSubview(self.textField)
    self.textFieldContainer.addSubview(self.horizontalStackView)

    self.textFieldContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    self.textField.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  @objc private func handleTap() {
    self.becomeFirstResponder()
  }

  @objc private func handleTextChange() {
    self.onValueChange(self.text)
  }

  // MARK: Style

  private func style() {
    Self.Style.textFieldContainer(self.textFieldContainer, model: self.model)
    Self.Style.horizontalStackView(self.horizontalStackView, model: self.model)
    Self.Style.verticalStackView(self.verticalStackView, model: self.model)
    Self.Style.textField(self.textField, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
    Self.Style.captionLabel(self.captionLabel, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.verticalStackView.allEdges()

    self.textFieldContainerConstraints = self.textFieldContainer.height(self.model.height)
    self.textFieldContainer.horizontally()

    self.horizontalStackView.vertically()
    self.horizontalStackViewConstraints = self.horizontalStackView.horizontally(self.model.horizontalPadding)

    self.captionLabel.horizontally()

    self.textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }

  // MARK: Update

  public func update(_ oldModel: InputFieldVM) {
    guard self.model != oldModel else { return }

    self.style()

    self.horizontalStackViewConstraints.leading?.constant = self.model.horizontalPadding
    self.horizontalStackViewConstraints.trailing?.constant = -self.model.horizontalPadding
    self.textFieldContainerConstraints.height?.constant = self.model.height

    if self.model.shouldUpdateTitlePosition(oldModel) {
      switch self.model.titlePosition {
      case .inside:
        self.verticalStackView.removeArrangedSubview(self.titleLabel)
        self.horizontalStackView.insertArrangedSubview(self.titleLabel, at: 0)
      case .outside:
        self.horizontalStackView.removeArrangedSubview(self.titleLabel)
        self.verticalStackView.insertArrangedSubview(self.titleLabel, at: 0)
      }
    }
    if self.model.shouldUpdateLayout(oldModel) {
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  // MARK: UIView Method

  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return self.textField.becomeFirstResponder()
  }

  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return self.textField.resignFirstResponder()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width: CGFloat
    if let parentWidth = self.superview?.bounds.width,
       parentWidth > 0 {
      width = parentWidth
    } else {
      width = 10_000
    }

    let height = self.verticalStackView.sizeThatFits(UIView.layoutFittingCompressedSize).height

    return .init(
      width: min(size.width, width),
      height: min(size.height, height)
    )
  }

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: Helpers

  @objc private func handleTraitChanges() {
    Self.Style.textFieldContainer(self.textFieldContainer, model: self.model)
  }
}

// MARK: - Style Helpers

extension UKInputField {
  @MainActor
  fileprivate enum Style {
    static func textFieldContainer(
      _ view: UIView,
      model: Model
    ) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value(for: model.height)
      view.layer.borderWidth = model.borderWidth
      view.layer.borderColor = model.borderColor.cgColor
    }
    static func titleLabel(
      _ label: UILabel,
      model: Model
    ) {
      label.attributedText = model.nsAttributedTitle
      label.isVisible = model.title.isNotNilAndEmpty
    }
    static func textField(
      _ textField: UITextField,
      model: Model
    ) {
      textField.font = model.preferredFont.uiFont
      textField.textColor = model.foregroundColor.uiColor
      textField.tintColor = model.tintColor.uiColor
      textField.attributedPlaceholder = model.nsAttributedPlaceholder
      textField.keyboardType = model.keyboardType
      textField.returnKeyType = model.submitType.returnKeyType
      textField.isSecureTextEntry = model.isSecureInput
      textField.isEnabled = model.isEnabled
      textField.autocorrectionType = model.autocorrectionType
      textField.autocapitalizationType = model.autocapitalization.textAutocapitalizationType
    }
    static func captionLabel(
      _ label: UILabel,
      model: Model
    ) {
      label.text = model.caption
      label.isVisible = model.caption.isNotNilAndEmpty
      label.textColor = model.captionColor.uiColor
      label.font = model.preferredCaptionFont.uiFont
      label.numberOfLines = 0
    }
    static func horizontalStackView(
      _ stackView: UIStackView,
      model: Model
    ) {
      stackView.axis = .horizontal
      stackView.spacing = model.spacing
    }
    static func verticalStackView(
      _ stackView: UIStackView,
      model: Model
    ) {
      stackView.axis = .vertical
      stackView.spacing = model.spacing
      stackView.alignment = .leading
      stackView.distribution = .fillProportionally
    }
  }
}
