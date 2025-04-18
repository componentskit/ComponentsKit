import AutoLayout
import UIKit

/// A UIKit component that displays a multi-line text input form.
open class UKTextInput: UIView, UKComponent {
  // MARK: - Properties

  /// A closure that is triggered when the text changes.
  public var onValueChange: (String) -> Void

  /// A model that defines the appearance properties.
  public var model: TextInputVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// A text inputted in the field.
  public var text: String {
    get {
      return self.textView.text ?? ""
    }
    set {
      guard newValue != self.text else { return }

      self.textView.text = newValue
      self.handleTextChanges()
    }
  }

  // MARK: - Subviews

  /// An underlying text view instance from the standard library.
  public var textView = UITextView()
  /// A label used to display placeholder text when the inputted text is empty.
  public var placeholderLabel = UILabel()

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  open override var isFirstResponder: Bool {
    return self.textView.isFirstResponder
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialText: A text that is initially inputted in the text input.
  ///   - model: A model that defines the appearance properties.
  ///   - onValueChange: A closure that is triggered when the text changes.
  public init(
    initialText: String = "",
    model: TextInputVM = .init(),
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

  // MARK: - Setup

  private func setup() {
    self.addSubview(self.textView)
    self.addSubview(self.placeholderLabel)

    self.textView.delegate = self
  }

  // MARK: - Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.placeholder(self.placeholderLabel, model: self.model)
    Self.Style.textView(self.textView, model: self.model)
  }

  // MARK: - Layout

  private func layout() {
    self.textView.allEdges()

    self.placeholderLabel.horizontally(self.model.contentPadding)
    self.placeholderLabel.top(self.model.contentPadding)
    self.placeholderLabel.heightAnchor.constraint(
      lessThanOrEqualTo: self.heightAnchor,
      constant: -2 * self.model.contentPadding
    ).isActive = true
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.updateCornerRadius()

    // During the first layout, text container insets in `UITextView` can change automatically, so we need to update them.
    Self.Style.textView(self.textView, padding: self.model.contentPadding)
  }

  // MARK: - Model Update

  public func update(_ oldModel: TextInputVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldUpdateLayout(oldModel) {
      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }
  }

  // MARK: - UIView Method

  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return self.textView.becomeFirstResponder()
  }

  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return self.textView.resignFirstResponder()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    var width = size.width
    if self.bounds.width > 0,
       self.bounds.width < width {
      width = self.bounds.width
    }

    let preferredHeight = TextInputHeightCalculator.preferredHeight(
      for: self.text,
      model: self.model,
      width: width
    )

    let height = min(
      max(preferredHeight, self.model.minTextInputHeight),
      self.model.maxTextInputHeight
    )

    return CGSize(width: width, height: height)
  }

  // MARK: - Helpers

  private func handleTextChanges() {
    self.onValueChange(self.text)

    self.placeholderLabel.isHidden = self.text.isNotEmpty

    self.invalidateIntrinsicContentSize()
  }

  private func updateCornerRadius() {
    self.layer.cornerRadius = self.model.adaptedCornerRadius(for: self.bounds.height)
  }
}

// MARK: - UITextViewDelegate Conformance

extension UKTextInput: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    self.handleTextChanges()
  }
}

// MARK: - Style Helpers

extension UKTextInput {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: TextInputVM) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.adaptedCornerRadius(for: view.bounds.height)
    }

    static func textView(
      _ textView: UITextView,
      model: TextInputVM
    ) {
      textView.font = model.preferredFont.uiFont
      textView.textColor = model.foregroundColor.uiColor
      textView.tintColor = model.tintColor.uiColor
      textView.autocorrectionType = model.autocorrectionType
      textView.autocapitalizationType = model.autocapitalization.textAutocapitalizationType
      textView.isEditable = model.isEnabled
      textView.isSelectable = model.isEnabled
      textView.backgroundColor = .clear
      Self.textView(textView, padding: model.contentPadding)
    }

    static func textView(_ textView: UITextView, padding: CGFloat) {
      textView.textContainer.lineFragmentPadding = 0
      textView.textContainerInset.top = padding
      textView.textContainerInset.left = padding
      textView.textContainerInset.right = padding
      textView.textContainerInset.bottom = padding
    }

    static func placeholder(
      _ label: UILabel,
      model: TextInputVM
    ) {
      label.font = model.preferredFont.uiFont
      label.textColor = model.placeholderColor.uiColor
      label.text = model.placeholder
      label.numberOfLines = 0
    }
  }
}
