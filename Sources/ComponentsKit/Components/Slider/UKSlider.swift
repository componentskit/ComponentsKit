import AutoLayout
import UIKit

/// A UIKit component that displays a slider.
open class UKSlider: UIView, UKComponent {
  // MARK: - Properties

  /// A closure that is triggered when the `currentValue` changes.
  public var onValueChange: (CGFloat) -> Void

  /// A model that defines the appearance properties.
  public var model: SliderVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// The current value of the slider.
  public var currentValue: CGFloat {
    didSet {
      guard self.currentValue != oldValue else { return }
      self.updateSliderAppearance()
      self.onValueChange(self.currentValue)
    }
  }

  // MARK: - Subviews

  /// The background view of the slider track.
  public let backgroundView = UIView()

  /// The filled portion of the slider track.
  public let barView = UIView()

  /// A shape layer used to render striped styling.
  public let stripedLayer = CAShapeLayer()

  /// The draggable handle representing the current value.
  public let handleView = UIView()

  /// An  overlay view for handle for the `large` style.
  private let handleOverlayView = UIView()

  // MARK: - Layout Constraints

  private var barViewConstraints = LayoutConstraints()
  private var backgroundViewConstraints = LayoutConstraints()
  private var handleViewConstraints = LayoutConstraints()

  // MARK: - Private Properties

  private var isDragging = false

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialValue: The initial slider value. Defaults to `0`.
  ///   - model: A model that defines the appearance properties.
  ///   - onValueChange: A closure triggered whenever `currentValue` changes.
  public init(
    initialValue: CGFloat = 0,
    model: SliderVM = .init(),
    onValueChange: @escaping (CGFloat) -> Void = { _ in }
  ) {
    self.currentValue = initialValue
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

  // MARK: - Setup

  private func setup() {
    self.addSubview(self.backgroundView)
    self.addSubview(self.barView)
    self.addSubview(self.handleView)
    self.backgroundView.layer.addSublayer(self.stripedLayer)
    self.handleView.addSubview(self.handleOverlayView)
  }

  // MARK: - Style

  private func style() {
    Self.Style.backgroundView(self.backgroundView, model: self.model)
    Self.Style.barView(self.barView, model: self.model)
    Self.Style.stripedLayer(self.stripedLayer, model: self.model)
    Self.Style.handleView(self.handleView, model: self.model)
    Self.Style.handleOverlayView(self.handleOverlayView, model: self.model)
  }

  // MARK: - Update

  public func update(_ oldModel: SliderVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldUpdateLayout(oldModel) {
      self.barViewConstraints.height?.constant = self.model.trackHeight
      self.backgroundViewConstraints.height?.constant = self.model.trackHeight
      self.handleViewConstraints.height?.constant = self.model.handleSize.height
      self.handleViewConstraints.width?.constant = self.model.handleSize.width

      UIView.performWithoutAnimation {
        self.layoutIfNeeded()
      }
    }

    self.updateSliderAppearance()
  }

  private func updateSliderAppearance() {
    if self.model.style == .striped {
      self.stripedLayer.frame = self.backgroundView.bounds
      self.stripedLayer.path = self.model.stripesBezierPath(in: self.stripedLayer.bounds).cgPath
    }

    let barWidth = self.model.barWidth(for: self.bounds.width, progress: self.progress)
    self.barViewConstraints.width?.constant = barWidth
  }

  // MARK: - Layout

  private func layout() {
    self.barViewConstraints = .merged {
      self.barView.leading()
      self.barView.centerVertically()
      self.barView.height(self.model.trackHeight)
      self.barView.width(0)
    }

    self.backgroundViewConstraints = .merged {
      self.backgroundView.trailing()
      self.backgroundView.centerVertically()
      self.backgroundView.height(self.model.trackHeight)
    }

    self.handleViewConstraints = .merged {
      self.handleView.after(self.barView, padding: self.model.trackSpacing)
      self.handleView.before(self.backgroundView, padding: self.model.trackSpacing)
      self.handleView.size(
        width: self.model.handleSize.width,
        height: self.model.handleSize.height
      )
      self.handleView.centerVertically()
    }

    self.handleOverlayView.center()
    self.handleOverlayView.size(
      width: self.model.handleOverlaySide,
      height: self.model.handleOverlaySide
    )
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.backgroundView.layer.cornerRadius =
    self.model.cornerRadius(for: self.backgroundView.bounds.height)

    self.barView.layer.cornerRadius =
    self.model.cornerRadius(for: self.barView.bounds.height)

    self.handleView.layer.cornerRadius =
    self.model.cornerRadius(for: self.handleView.bounds.width)

    self.handleOverlayView.layer.cornerRadius =
    self.model.cornerRadius(for: self.handleOverlayView.bounds.width)

    self.updateSliderAppearance()
    self.model.validateMinMaxValues()
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width: CGFloat
    if let parentWidth = self.superview?.bounds.width,
       parentWidth > 0 {
      width = parentWidth
    } else {
      width = 10_000
    }
    return CGSize(
      width: min(size.width, width),
      height: min(size.height, self.model.handleSize.height)
    )
  }

  open override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    guard let point = touches.first?.location(in: self),
          self.hitTest(point, with: nil) == self.handleView
    else { return }

    self.isDragging = true
  }

  open override func touchesMoved(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    guard self.isDragging,
          let translation = touches.first?.location(in: self)
    else { return }

    let totalWidth = self.bounds.width
    let sliderWidth = max(0, totalWidth - self.model.handleSize.width - 2 * self.model.trackSpacing)

    let newOffset = translation.x - self.model.trackSpacing - self.model.handleSize.width / 2
    let clampedOffset = min(max(newOffset, 0), sliderWidth)

    self.currentValue = self.model.steppedValue(for: clampedOffset, trackWidth: sliderWidth)
  }

  open override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    self.isDragging = false
  }

  open override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    self.isDragging = false
  }
}

// MARK: - Style Helpers

extension UKSlider {
  fileprivate enum Style {
    static func backgroundView(_ view: UIView, model: SliderVM) {
      view.backgroundColor = model.color.background.uiColor
      if model.style == .striped {
        view.backgroundColor = .clear
      }
      view.layer.cornerRadius = model.cornerRadius(for: view.bounds.height)
      view.layer.masksToBounds = true
    }

    static func barView(_ view: UIView, model: SliderVM) {
      view.backgroundColor = model.color.main.uiColor
      view.layer.cornerRadius = model.cornerRadius(for: view.bounds.height)
      view.layer.masksToBounds = true
    }

    static func stripedLayer(_ layer: CAShapeLayer, model: SliderVM) {
      layer.fillColor = model.color.main.uiColor.cgColor
      switch model.style {
      case .light:
        layer.isHidden = true
      case .striped:
        layer.isHidden = false
      }
    }

    static func handleView(_ view: UIView, model: SliderVM) {
      view.backgroundColor = model.color.main.uiColor
      view.layer.cornerRadius = model.cornerRadius(for: model.handleSize.width)
      view.layer.masksToBounds = true
    }

    static func handleOverlayView(_ view: UIView, model: SliderVM) {
      view.isVisible = model.isHandleOverlayVisible
      view.backgroundColor = model.color.contrast.uiColor
      view.layer.cornerRadius = model.cornerRadius(for: model.handleOverlaySide)
    }
  }
}
