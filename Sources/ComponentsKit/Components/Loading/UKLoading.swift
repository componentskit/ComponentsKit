import UIKit

/// A UIKit component that shows that a task is in progress.
open class UKLoading: UIView, UKComponent {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: LoadingVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  open override var isHidden: Bool {
    didSet {
      guard self.isHidden != oldValue else { return }

      if self.isHidden {
        self.shapeLayer.removeAllAnimations()
      } else {
        self.addSpinnerAnimation()
      }
    }
  }

  // MARK: Layers

  /// A layer that draws a loader.
  public let shapeLayer = CAShapeLayer()

  // MARK: Initializers

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: LoadingVM = .init()) {
    self.model = model
    super.init(frame: .zero)

    self.setup()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Deinitialization

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Setup

  private func setup() {
    self.setupLayer()
    self.layer.addSublayer(self.shapeLayer)

    self.addSpinnerAnimation()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleAppMovedFromBackground),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  private func setupLayer() {
    self.shapeLayer.lineWidth = self.model.loadingLineWidth
    self.shapeLayer.strokeColor = self.model.color.main.uiColor.cgColor
    self.shapeLayer.fillColor = UIColor.clear.cgColor
    self.shapeLayer.lineCap = self.model.lineCap.shapeLayerLineCap
    self.shapeLayer.strokeEnd = 0.75
  }

  @objc private func handleAppMovedFromBackground() {
    self.addSpinnerAnimation()
  }

  // MARK: Update

  public func update(_ oldModel: LoadingVM) {
    guard self.model != oldModel else { return }

    self.shapeLayer.lineWidth = self.model.loadingLineWidth
    self.shapeLayer.strokeColor = self.model.color.main.uiColor.cgColor
    self.shapeLayer.lineCap = self.model.lineCap.shapeLayerLineCap

    if self.model.shouldUpdateShapePath(oldModel) {
      self.updateShapePath()

      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }
  }

  private func updateShapePath() {
    let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    let radius = min(self.bounds.height, self.bounds.width) / 2 - self.model.loadingLineWidth
    self.shapeLayer.path = UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: 0,
      endAngle: 2 * .pi,
      clockwise: true
    ).cgPath
  }

  // MARK: Layout

  open override func layoutSubviews() {
    super.layoutSubviews()

    CATransaction.begin()
    CATransaction.setDisableActions(true)
    self.shapeLayer.frame = self.bounds
    self.updateShapePath()
    CATransaction.commit()

    if self.isVisible {
      self.addSpinnerAnimation()
    }
  }

  // MARK: UIView methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let preferredSize = self.model.preferredSize ?? size
    return .init(
      width: min(preferredSize.width, size.width),
      height: min(preferredSize.height, size.height)
    )
  }

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: Helpers

  private func addSpinnerAnimation() {
    let animationKey = "rotationAnimation"

    guard self.shapeLayer.animation(forKey: animationKey).isNil else {
      return
    }

    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.fromValue = 0
    rotationAnimation.toValue = CGFloat.pi * 2
    rotationAnimation.duration = 1.0
    rotationAnimation.repeatCount = .infinity
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
    self.shapeLayer.add(rotationAnimation, forKey: animationKey)
  }

  private func handleTraitChanges() {
    self.shapeLayer.strokeColor = self.model.color.main.uiColor.cgColor
  }
}
