import AutoLayout
import UIKit

/// A UIKit component that displays the progress of a task or operation in a circular form.
open class UKCircularProgress: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties for the circular progress.
  public var model: CircularProgressVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// The current progress value.
  public var currentValue: CGFloat? {
    didSet {
      self.updateProgress()
    }
  }

  private var progress: CGFloat {
    self.currentValue.map { self.model.progress(for: $0) } ?? self.model.progress
  }

  // MARK: - Subviews

  /// The shape layer responsible for rendering the background.
  public let backgroundLayer = CAShapeLayer()

  /// The shape layer responsible for rendering the progress arc.
  public let progressLayer = CAShapeLayer()

  /// The label used to display text.
  public let label = UILabel()

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialValue: The initial progress value. Defaults to `0`.
  ///   - model: The model that defines the appearance properties.
  @available(*, deprecated, message: "Set `currentValue` in the model instead.")
  public init(
    initialValue: CGFloat = 0,
    model: CircularProgressVM = .init()
  ) {
    self.model = model
    self.currentValue = initialValue
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  /// Initializer.
  /// - Parameters:
  ///   - model: The model that defines the appearance properties.
  public init(model: CircularProgressVM) {
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
    self.layer.addSublayer(self.backgroundLayer)
    self.layer.addSublayer(self.progressLayer)
    self.addSubview(self.label)

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }

    self.progressLayer.strokeEnd = self.progress
    self.label.text = self.model.label
  }

  // MARK: - Style

  private func style() {
    Self.Style.backgroundLayer(self.backgroundLayer, model: self.model)
    Self.Style.progressLayer(self.progressLayer, model: self.model)
    Self.Style.label(self.label, model: self.model)
  }

  // MARK: - Update

  public func update(_ oldModel: CircularProgressVM) {
    guard self.model != oldModel else { return }
    self.style()

    if self.model.shouldUpdateText(oldModel) {
      UIView.transition(
        with: self.label,
        duration: self.model.animationDuration,
        options: .transitionCrossDissolve,
        animations: {
          self.label.text = self.model.label
        },
        completion: nil
      )
    }
    if self.model.shouldRecalculateProgress(oldModel) {
      self.updateProgress()
    }
    if self.model.shouldUpdateShape(oldModel) {
      self.updateShapePaths()
    }
    if self.model.shouldInvalidateIntrinsicContentSize(oldModel) {
      self.invalidateIntrinsicContentSize()
    }
  }

  private func updateShapePaths() {
    let circlePath = UIBezierPath(
      arcCenter: self.model.center(size: self.bounds.size),
      radius: self.model.radius(size: self.bounds.size),
      startAngle: self.model.startAngle,
      endAngle: self.model.endAngle,
      clockwise: true
    )

    self.backgroundLayer.path = circlePath.cgPath
    self.progressLayer.path = circlePath.cgPath
  }

  private func updateProgress() {
    CATransaction.begin()
    CATransaction.setAnimationDuration(self.model.animationDuration)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
    self.progressLayer.strokeEnd = self.progress
    CATransaction.commit()
  }

  // MARK: - Layout

  private func layout() {
    self.label.center()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.backgroundLayer.frame = self.bounds
    self.progressLayer.frame = self.bounds

    self.updateShapePaths()
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let preferredSize = self.model.preferredSize ?? size
    return .init(
      width: min(preferredSize.width, size.width),
      height: min(preferredSize.height, size.height)
    )
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  private func handleTraitChanges() {
    Self.Style.backgroundLayer(self.backgroundLayer, model: self.model)
    Self.Style.progressLayer(self.progressLayer, model: self.model)
  }
}

// MARK: - Style Helpers

extension UKCircularProgress {
  fileprivate enum Style {
    static func backgroundLayer(
      _ layer: CAShapeLayer,
      model: CircularProgressVM
    ) {
      layer.fillColor = UIColor.clear.cgColor
      layer.strokeColor = model.color.background.cgColor
      layer.lineCap = model.lineCap.shapeLayerLineCap
      layer.lineWidth = model.circularLineWidth
    }

    static func progressLayer(
      _ layer: CAShapeLayer,
      model: CircularProgressVM
    ) {
      layer.fillColor = UIColor.clear.cgColor
      layer.strokeColor = model.color.main.uiColor.cgColor
      layer.lineCap = model.lineCap.shapeLayerLineCap
      layer.lineWidth = model.circularLineWidth
    }

    static func label(
      _ label: UILabel,
      model: CircularProgressVM
    ) {
      label.textAlignment = .center
      label.font = model.titleFont.uiFont
      label.textColor = model.color.main.uiColor
    }
  }
}
