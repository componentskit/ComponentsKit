import AutoLayout
import UIKit

/// A UIKit component that can be selected by a user.
open class UKCheckbox: UIView, UKComponent {
  // MARK: Properties

  /// A closure that is triggered when the checkbox is selected or unselected.
  public var onValueChange: (Bool) -> Void

  /// A model that defines the appearance properties.
  public var model: CheckboxVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// A Boolean value indicating whether the checkbox is selected.
  public var isSelected: Bool {
    didSet {
      guard self.isSelected != oldValue else { return }
      self.updateSelection()
      self.onValueChange(self.isSelected)
    }
  }

  private var titleLabelConstraints: LayoutConstraints = .init()
  private var checkboxContainerConstraints: LayoutConstraints = .init()

  // MARK: Subviews

  /// A stack view that contains a checkbox and a title label.
  public var stackView = UIStackView()
  /// A label that displays the title from the model.
  public var titleLabel = UILabel()
  /// A view that contains another view with a checkmark.
  ///
  /// Animates the checkbox border.
  public var checkboxContainer = UIView()
  /// A view that contains a checkmark.
  ///
  /// Animates the checkbox background.
  public var checkboxBackground = UIView()
  /// A layer that draws a checkmark.
  public var checkmarkLayer = CAShapeLayer()

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - isSelected: A Binding Boolean value indicating whether the checkbox is selected.
  ///   - model: A model that defines the appearance properties.
  ///   - onValueChange: A closure that is triggered when the checkbox is selected or unselected.
  public init(
    initialValue: Bool = false,
    model: CheckboxVM = .init(),
    onValueChange: @escaping (Bool) -> Void = { _ in }
  ) {
    self.isSelected = initialValue
    self.model = model
    self.onValueChange = onValueChange
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
    self.checkboxContainer.addSubview(self.checkboxBackground)
    self.stackView.addArrangedSubview(self.checkboxContainer)
    if self.model.title.isNotNilAndEmpty {
      self.stackView.addArrangedSubview(self.titleLabel)
    }

    self.checkboxContainer.layer.addSublayer(self.checkmarkLayer)

    self.setupCheckmarkLayer()

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  private func setupCheckmarkLayer() {
    self.checkmarkLayer.fillColor = UIColor.clear.cgColor
    self.checkmarkLayer.lineCap = .round
    self.checkmarkLayer.lineJoin = .round
    self.checkmarkLayer.strokeEnd = self.isSelected ? 1.0 : 0.0
    self.checkmarkLayer.path = self.model.checkmarkPath
  }

  // MARK: Style

  private func style() {
    Self.Style.stackView(self.stackView, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
    Self.Style.checkboxContainer(self.checkboxContainer, model: self.model)
    Self.Style.checkboxBackground(self.checkboxBackground, model: self.model)
    Self.Style.checkmarkLayer(self.checkmarkLayer, model: self.model)

    self.checkboxBackground.alpha = self.isSelected ? 1.0 : 0.0
    self.checkboxContainer.layer.borderColor = self.isSelected
    ? UIColor.clear.cgColor
    : self.model.borderColor.uiColor.cgColor
  }

  // MARK: Layout

  private func layout() {
    self.stackView.allEdges()

    self.checkboxContainerConstraints = self.checkboxContainer.size(self.model.checkboxSide)
    self.checkboxBackground.allEdges()
  }

  // MARK: Update

  public func update(_ oldModel: CheckboxVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldAddLabel(oldModel) {
      self.stackView.addArrangedSubview(self.titleLabel)
    } else if self.model.shouldRemoveLabel(oldModel) {
      self.stackView.removeArrangedSubview(self.titleLabel)
    }
    if self.model.shouldUpdateSize(oldModel) {
      self.checkboxContainerConstraints.height?.constant = self.model.checkboxSide
      self.checkboxContainerConstraints.width?.constant = self.model.checkboxSide
      self.setupCheckmarkLayer()
    }
    if self.model.shouldUpdateLayout(oldModel) {
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  private func updateSelection() {
    if self.isSelected {
      self.animateSelection()
    } else {
      self.animateDeselection()
    }
  }

  // MARK: UIView methods

  open override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesEnded(touches, with: event)

    self.handleCheckboxTap(touches, with: event)
  }

  open override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesCancelled(touches, with: event)

    self.handleCheckboxTap(touches, with: event)
  }

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: Helpers

  private func handleCheckboxTap(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    if self.model.isEnabled,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.isSelected.toggle()
    }
  }

  private func animateSelection() {
    UIView.animate(
      withDuration: CheckboxAnimationDurations.background,
      delay: 0.0,
      options: [.curveEaseInOut],
      animations: {
        self.checkboxBackground.alpha = 1.0
        self.checkboxBackground.transform = .identity
      }, completion: { _ in
        guard self.isSelected else { return }
        CATransaction.begin()
        CATransaction.setAnimationDuration(CheckboxAnimationDurations.checkmarkStroke)
        self.checkmarkLayer.strokeEnd = 1.0
        CATransaction.commit()
      }
    )

    UIView.animate(
      withDuration: CheckboxAnimationDurations.borderOpacity,
      delay: CheckboxAnimationDurations.selectedBorderDelay,
      animations: {
        self.checkboxContainer.layer.borderColor = UIColor.clear.cgColor
      }
    )
  }

  private func animateDeselection() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    self.checkmarkLayer.strokeEnd = 0.0
    CATransaction.commit()

    UIView.animate(
      withDuration: CheckboxAnimationDurations.background,
      delay: 0.0,
      options: [.curveEaseInOut]
    ) {
      self.checkboxBackground.alpha = 0.0
      self.checkboxBackground.transform = .init(scaleX: 0.1, y: 0.1)
    }

    UIView.animate(
      withDuration: CheckboxAnimationDurations.borderOpacity,
      animations: {
        self.checkboxContainer.layer.borderColor = self.model.borderColor.uiColor.cgColor
      }
    )
  }

  @objc private func handleTraitChanges() {
    self.checkboxContainer.layer.borderColor = self.isSelected
    ? UIColor.clear.cgColor
    : self.model.borderColor.uiColor.cgColor
    Self.Style.checkmarkLayer(self.checkmarkLayer, model: self.model)
  }
}

// MARK: - Style Helpers

extension UKCheckbox {
  fileprivate enum Style {
    static func stackView(_ stackView: UIStackView, model: Model) {
      stackView.axis = .horizontal
      stackView.spacing = model.spacing
      stackView.alignment = .center
    }
    static func titleLabel(_ label: UILabel, model: Model) {
      label.textColor = model.titleColor.uiColor
      label.numberOfLines = 0
      label.text = model.title
      label.textColor = model.titleColor.uiColor
      label.font = model.titleFont.uiFont
    }
    static func checkboxContainer(_ view: UIView, model: Model) {
      view.layer.cornerRadius = model.checkboxCornerRadius
      view.layer.borderWidth = model.borderWidth
      view.layer.borderColor = model.borderColor.uiColor.cgColor
    }
    static func checkboxBackground(_ view: UIView, model: Model) {
      view.layer.cornerRadius = model.checkboxCornerRadius
      view.backgroundColor = model.backgroundColor.uiColor
    }
    static func checkmarkLayer(_ layer: CAShapeLayer, model: Model) {
      layer.strokeColor = model.foregroundColor.uiColor.cgColor
      layer.lineWidth = model.checkmarkLineWidth
    }
  }
}
