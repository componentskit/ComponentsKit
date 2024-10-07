import UIKit

/// A UIKit component that displays a field to input a text.
open class UKInputField: UIView, UKComponent {
  // MARK: Properties

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
      return self.inputField.text ?? ""
    }
    set {
      guard newValue != self.text else { return }

      self.inputField.text = newValue
      self.onValueChange(newValue)
      self.titlePosition = Self.getTitlePosition(
        isSelected: self.inputField.isFirstResponder,
        hasText: newValue.isNotEmpty,
        hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
      )
    }
  }

  private var titlePosition: InputFieldTitlePosition {
    didSet {
      if self.titlePosition != oldValue {
        self.updateTitlePosition()
      }
    }
  }

  private var titleLabelConstraints: AnchoredConstraints = .init()
  private var inputFieldConstraints: AnchoredConstraints = .init()

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()
  /// An underlying input field from the standard library.
  public var inputField = UITextField()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  open override var isFirstResponder: Bool {
    return self.inputField.isFirstResponder
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
    self.titlePosition = Self.getTitlePosition(
      isSelected: false,
      hasText: initialText.isNotEmpty,
      hasPlaceholder: model.placeholder.isNotNilAndEmpty
    )
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
    self.addSubview(self.titleLabel)
    self.addSubview(self.inputField)

    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    self.inputField.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)

    self.inputField.delegate = self
  }

  @objc private func handleTap() {
    self.becomeFirstResponder()
  }

  @objc private func handleTextChange() {
    self.onValueChange(self.text)
  }

  // MARK: Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.inputField(self.inputField, model: self.model)
    Self.Style.titleLabel(
      self.titleLabel,
      position: self.titlePosition,
      model: self.model
    )
  }

  // MARK: Layout

  private func layout() {
    self.titleLabelConstraints = self.titleLabel.horizontally(self.model.horizontalPadding)
    self.titleLabelConstraints.top = self.titleLabel.top(self.model.verticalPadding)
    self.titleLabelConstraints.vertical = self.titleLabel.centerVertically()

    switch self.titlePosition {
    case .top:
      self.titleLabelConstraints.vertical?.isActive = false
    case .center:
      self.titleLabelConstraints.top?.isActive = false
    }

    self.inputFieldConstraints = self.inputField.horizontally(self.model.horizontalPadding)
    self.inputFieldConstraints.top = self.inputField.top(self.model.inputFieldTopPadding)
    self.inputFieldConstraints.bottom = self.inputField.bottom(self.model.verticalPadding)
    self.inputFieldConstraints.height = self.inputField.height(self.model.inputFieldHeight)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: InputFieldVM) {
    guard self.model != oldModel else { return }

    self.titlePosition = Self.getTitlePosition(
      isSelected: self.inputField.isFirstResponder,
      hasText: self.text.isNotEmpty,
      hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
    )

    self.style()

    if self.model.shouldUpdateLayout(oldModel) {
      self.titleLabelConstraints.leading?.constant = self.model.horizontalPadding
      self.titleLabelConstraints.trailing?.constant = -self.model.horizontalPadding
      self.inputFieldConstraints.leading?.constant = self.model.horizontalPadding
      self.inputFieldConstraints.trailing?.constant = -self.model.horizontalPadding
      self.inputFieldConstraints.top?.constant = self.model.inputFieldTopPadding
      self.inputFieldConstraints.bottom?.constant = -self.model.verticalPadding
      self.inputFieldConstraints.height?.constant = self.model.inputFieldHeight

      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  // MARK: UIView Method

  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return self.inputField.becomeFirstResponder()
  }

  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return self.inputField.resignFirstResponder()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width: CGFloat
    if let parentWidth = self.superview?.bounds.width,
       parentWidth > 0 {
      width = parentWidth
    } else {
      width = 10_000
    }
    return .init(
      width: min(size.width, width),
      height: size.height
    )
  }

  // MARK: Helpers

  private static func getTitlePosition(
    isSelected: Bool,
    hasText: Bool,
    hasPlaceholder: Bool
  ) -> InputFieldTitlePosition {
    if !hasPlaceholder, !hasText, !isSelected {
      return .center
    } else {
      return .top
    }
  }

  private func updateTitlePosition() {
    Self.Style.titleLabel(
      self.titleLabel,
      position: self.titlePosition,
      model: self.model
    )

    switch self.titlePosition {
    case .center:
      self.titleLabelConstraints.top?.isActive = false
      self.titleLabelConstraints.vertical?.isActive = true
    case .top:
      self.titleLabelConstraints.vertical?.isActive = false
      self.titleLabelConstraints.top?.isActive = true
    }
    UIView.animate(withDuration: 0.2) {
      self.layoutIfNeeded()
    }
  }
}

extension UKInputField: UITextFieldDelegate {
  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if !textField.isFirstResponder {
      self.titlePosition = Self.getTitlePosition(
        isSelected: true,
        hasText: self.text.isNotEmpty,
        hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
      )
    }

    return true
  }

  public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.isFirstResponder {
      self.titlePosition = Self.getTitlePosition(
        isSelected: false,
        hasText: self.text.isNotEmpty,
        hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
      )
    }

    return true
  }
}

// MARK: - Style Helpers

extension UKInputField {
  fileprivate enum Style {
    static func mainView(
      _ view: UIView,
      model: InputFieldVM
    ) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value(for: view.bounds.height)
    }
    static func titleLabel(
      _ label: UILabel,
      position: InputFieldTitlePosition,
      model: InputFieldVM
    ) {
      label.attributedText = model.nsAttributedTitle(for: position)
    }
    static func inputField(
      _ inputField: UITextField,
      model: InputFieldVM
    ) {
      inputField.font = model.preferredFont.uiFont
      inputField.textColor = model.foregroundColor.uiColor
      inputField.tintColor = model.tintColor.uiColor
      inputField.attributedPlaceholder = model.nsAttributedPlaceholder
      inputField.keyboardType = model.keyboardType
      inputField.returnKeyType = model.submitType.returnKeyType
      inputField.isSecureTextEntry = model.isSecureInput
      inputField.isEnabled = model.isEnabled
      inputField.autocorrectionType = model.autocorrectionType
      inputField.autocapitalizationType = model.autocapitalization.textAutocapitalizationType
    }
  }
}
