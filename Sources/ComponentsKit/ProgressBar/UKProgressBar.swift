import AutoLayout
import UIKit

/// A UIKit component that displays a Progress Bar.
open class UKProgressBar: UIView, UKComponent {
  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width = self.superview?.bounds.width ?? size.width
    return CGSize(
      width: min(size.width, width),
      height: min(size.height, self.model.barHeight)
    )
  }

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: ProgressBarVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// The current progress value for the progress bar.
  public var currentValue: CGFloat {
    didSet {
      self.updateProgressBar()
    }
  }

  // MARK: - Subviews

  private let backgroundView = UIView()
  private let progressView = UIView()
  private let stripedLayer = UIView()

  // MARK: - Layout Constraints

  private var backgroundViewConstraints: LayoutConstraints = .init()
  private var progressViewConstraints: LayoutConstraints = .init()
  private var stripedViewConstraints: LayoutConstraints = .init()

  // MARK: - Private Properties

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: The initial progress value. Defaults to `0`.
  ///   - model: A model that defines the appearance properties.
  public init(
    initialValue: CGFloat = 0,
    model: ProgressBarVM = .init()
  ) {
    self.currentValue = initialValue
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
    self.addSubview(self.backgroundView)
    self.addSubview(self.progressView)
    self.addSubview(self.stripedLayer)
  }

  // MARK: - Style

  private func style() {
    Self.Style.backgroundView(self.backgroundView, model: self.model)
    Self.Style.progressView(self.progressView, model: self.model)
    Self.Style.stripedLayer(self.stripedLayer, model: self.model)
  }

  // MARK: - Layout

  private func layout() {
    self.backgroundViewConstraints.deactivateAll()
    self.progressViewConstraints.deactivateAll()
    self.stripedViewConstraints.deactivateAll()

    UIView.performWithoutAnimation {
      switch self.model.style {
      case .light:
        self.backgroundViewConstraints = .merged {
          self.backgroundView.after(self.progressView, padding: 4)
          self.backgroundView.centerVertically()
          self.backgroundView.height(self.model.barHeight)
          self.backgroundView.width(0)
        }
        self.progressViewConstraints = .merged {
          self.progressView.leading(0)
          self.progressView.centerVertically()
          self.progressView.height(self.model.barHeight)
          self.progressView.width(0)
        }

      case .filled, .striped:
        self.backgroundViewConstraints = .merged {
          self.backgroundView.horizontally(0)
          self.backgroundView.centerVertically()
          self.backgroundView.height(self.model.barHeight)
        }
        self.progressViewConstraints = .merged {
          self.progressView.leading(3, to: self.backgroundView)
          self.progressView.vertically(3, to: self.backgroundView)
          self.progressView.width(0)
        }

        if self.model.style == .striped {
          self.stripedViewConstraints = .merged {
            self.stripedLayer.horizontally(0)
            self.stripedLayer.centerVertically()
            self.stripedLayer.height(self.model.barHeight)
          }
        }
      }
    }

    self.setNeedsLayout()
  }

  // MARK: - Update

  public func update(_ oldModel: ProgressBarVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldUpdateLayout(oldModel) {
      self.layout()
      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }

    self.updateProgressBar()
  }

  private func updateProgressBar() {
    let duration: TimeInterval = 0.3

    UIView.performWithoutAnimation {
      self.layoutIfNeeded()
    }

    let totalWidth = self.bounds.width - self.model.horizontalPadding
    let progressWidth = totalWidth * self.progress

    switch self.model.style {
    case .light:
      self.progressViewConstraints.width?.constant = max(0, progressWidth)
      self.backgroundViewConstraints.width?.constant = max(0, totalWidth - progressWidth)

    case .filled, .striped:
      self.progressViewConstraints.width?.constant = max(0, progressWidth)
    }

    if self.model.style == .striped {
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = self.model.stripesBezierPath(in: self.stripedLayer.bounds).cgPath
      self.stripedLayer.layer.mask = shapeLayer
    }

    UIView.animate(withDuration: duration) {
      self.layoutIfNeeded()
    }
  }

  // MARK: - Style Helpers

  open override func layoutSubviews() {
    super.layoutSubviews()

    switch self.model.style {
    case .light:
      self.backgroundView.layer.cornerRadius = self.model.cornerRadius(forHeight: self.backgroundView.bounds.height)
      self.progressView.layer.cornerRadius = self.model.cornerRadius(forHeight: self.backgroundView.bounds.height)

    case .filled:
      self.backgroundView.layer.cornerRadius = self.model.cornerRadius(forHeight: self.backgroundView.bounds.height)
      self.progressView.layer.cornerRadius = self.model.innerCornerRadius(forHeight: self.backgroundView.bounds.height)

    case .striped:
      self.backgroundView.layer.cornerRadius = self.model.cornerRadius(forHeight: self.backgroundView.bounds.height)
      self.progressView.layer.cornerRadius = self.model.innerCornerRadius(forHeight: self.backgroundView.bounds.height)
      self.stripedLayer.layer.cornerRadius = self.model.cornerRadius(forHeight: self.backgroundView.bounds.height)
      self.stripedLayer.clipsToBounds = true
    }

    self.updateProgressBar()
    self.layoutIfNeeded()
  }
}

extension UKProgressBar {
  fileprivate enum Style {
    static func backgroundView(_ view: UIView, model: ProgressBarVM) {
      switch model.style {
      case .light:
        view.backgroundColor = model.backgroundColor.uiColor
      case .filled, .striped:
        view.backgroundColor = model.color.main.uiColor
      }
    }

    static func progressView(_ view: UIView, model: ProgressBarVM) {
      switch model.style {
      case .light:
        view.backgroundColor = model.barColor.uiColor
      case .filled, .striped:
        view.backgroundColor = model.color.contrast.uiColor
      }
    }

    static func stripedLayer(_ view: UIView, model: ProgressBarVM) {
      switch model.style {
      case .light, .filled:
        view.backgroundColor = .clear
        view.isHidden = true
      case .striped:
        view.backgroundColor = model.color.main.uiColor
        view.isHidden = false
      }
    }
  }
}
