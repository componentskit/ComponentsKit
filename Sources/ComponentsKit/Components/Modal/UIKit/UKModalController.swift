import AutoLayout
import UIKit

/// A generic class that defines shared behavior for modal controllers.
open class UKModalController<VM: ModalVM>: UIViewController {
  // MARK: - Typealiases

  /// A typealias for content providers, which create views for the header, body, or footer.
  /// The content provider closure receives a dismiss action that can be called to close the modal.
  public typealias Content = @MainActor (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView

  // MARK: - Properties

  /// A model that defines the appearance properties.
  public let model: VM

  private var contentViewWidthConstraint: NSLayoutConstraint?
  var contentViewBottomConstraint: NSLayoutConstraint?

  // MARK: - Subviews

  /// The optional header view of the modal.
  public var header: UIView?
  /// The main body view of the modal.
  public var body = UIView()
  /// The optional footer view of the modal.
  public var footer: UIView?
  /// The content view, holding the header, body, and footer.
  public let contentView = UIView()
  /// The visual effect container used to render blur and liquid glass modal backgrounds.
  public let backgroundEffectView = UIVisualEffectView()
  /// A scrollable wrapper for the body content.
  public let bodyWrapper: UIScrollView = ContentSizedScrollView()
  /// The overlay view that appears behind the modal.
  public let overlay: UIView

  // MARK: - Initialization

  init(model: VM) {
    self.model = model

    switch model.overlayStyle {
    case .dimmed, .transparent:
      self.overlay = UIView()
    case .blurred:
      self.overlay = UIVisualEffectView()
    }

    super.init(nibName: nil, bundle: nil)

    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Deinitialization

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
    self.style()
    self.layout()
  }

  // MARK: - Setup

  /// Sets up the modal's subviews, gesture recognizers and observers.
  open func setup() {
    self.view.addSubview(self.overlay)
    self.view.addSubview(self.contentView)
    self.contentView.addSubview(self.backgroundEffectView)
    if let header {
      self.backgroundEffectView.contentView.addSubview(header)
    }
    self.backgroundEffectView.contentView.addSubview(self.bodyWrapper)
    if let footer {
      self.backgroundEffectView.contentView.addSubview(footer)
    }

    self.bodyWrapper.addSubview(self.body)

    self.overlay.addGestureRecognizer(UITapGestureRecognizer(
      target: self,
      action: #selector(self.handleOverlayTap)
    ))

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (controller: Self, _: UITraitCollection) in
        controller.handleTraitChanges()
      }
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleKeyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleKeyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc func handleOverlayTap() {
    guard self.model.closesOnOverlayTap else { return }
    self.dismiss(animated: true)
  }

  @objc func handleKeyboardWillShow(notification: NSNotification) {
    if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat ?? 0.25
      UIView.animate(withDuration: duration) {
        self.contentViewBottomConstraint?.constant = -keyboardHeight - self.model.contentPaddings.bottom + self.view.safeAreaInsets.bottom
        self.view.layoutIfNeeded()
      }
    }
  }

  @objc func handleKeyboardWillHide(notification: NSNotification) {
    let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat ?? 0.25
    UIView.animate(withDuration: duration) {
      self.contentViewBottomConstraint?.constant = -self.model.contentPaddings.bottom
      self.view.layoutIfNeeded()
    }
  }

  // MARK: - Style

  /// Applies styling to the modal's subviews.
  open func style() {
    Self.Style.overlay(self.overlay, model: self.model)
    Self.Style.contentView(self.contentView, model: self.model)
    Self.Style.backgroundEffectView(self.backgroundEffectView, model: self.model)
    Self.Style.bodyWrapper(self.bodyWrapper)
  }

  // MARK: - Layout

  /// Configures the layout of the modal's subviews.
  open func layout() {
    self.overlay.allEdges()
    self.backgroundEffectView.allEdges()

    if let header {
      header.top(self.model.contentPaddings.top)
      header.leading(self.model.contentPaddings.leading)
      header.trailing(self.model.contentPaddings.trailing)
      header.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

      self.bodyWrapper.below(header, padding: self.model.contentSpacing)
      self.body.top()
    } else {
      self.bodyWrapper.top()
      self.body.top(self.model.contentPaddings.top)
    }

    if let footer {
      footer.bottom(self.model.contentPaddings.bottom)
      footer.leading(self.model.contentPaddings.leading)
      footer.trailing(self.model.contentPaddings.trailing)
      footer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

      self.bodyWrapper.above(footer, padding: self.model.contentSpacing)
      self.body.bottom()
    } else {
      self.bodyWrapper.bottom()
      self.body.bottom(self.model.contentPaddings.top)
    }

    self.bodyWrapper.horizontally()
    self.bodyWrapper.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

    self.body.leading(self.model.contentPaddings.leading, to: self.contentView)
    self.body.trailing(self.model.contentPaddings.trailing, to: self.contentView)

    self.contentView.topAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor,
      constant: self.model.outerPaddings.top
    ).isActive = true
    self.contentView.leadingAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor,
      constant: self.model.outerPaddings.leading
    ).isActive = true
    self.contentView.trailingAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor,
      constant: -self.model.outerPaddings.trailing
    ).isActive = true
    self.contentView.heightAnchor.constraint(
      greaterThanOrEqualToConstant: 80
    ).isActive = true

    self.contentViewWidthConstraint = self.contentView.width(self.model.size.maxWidth).width
    self.contentViewWidthConstraint?.priority = .defaultHigh

    self.bodyWrapper.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true

    self.contentView.centerHorizontally()
  }

  open override func viewWillTransition(
    to size: CGSize,
    with coordinator: any UIViewControllerTransitionCoordinator
  ) {
    self.contentViewWidthConstraint?.isActive = false
    super.viewWillTransition(to: size, with: coordinator)
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    let availableWidth = self.view.bounds.width
    let requiredWidth = self.model.size.maxWidth
    + self.model.outerPaddings.leading
    + self.model.outerPaddings.trailing
    if availableWidth > requiredWidth {
      self.contentViewWidthConstraint?.priority = .required
    } else {
      self.contentViewWidthConstraint?.priority = .defaultHigh
    }
    self.contentViewWidthConstraint?.isActive = true
  }

  // MARK: - UIViewController Methods

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: - Helpers

  @objc private func handleTraitChanges() {
    Self.Style.contentView(self.contentView, model: self.model)
    Self.Style.backgroundEffectView(self.backgroundEffectView, model: self.model)
  }
}

// MARK: - Style Helpers

extension UKModalController {
  @MainActor
  enum Style {
    static func overlay(_ view: UIView, model: VM) {
      switch model.overlayStyle {
      case .dimmed:
        view.backgroundColor = .black.withAlphaComponent(0.35)
      case .transparent:
        view.backgroundColor = .clear
      case .blurred:
        (view as? UIVisualEffectView)?.effect = UIBlurEffect(style: .systemUltraThinMaterial)
      }
    }
    static func contentView(_ view: UIView, model: VM) {
      view.layer.cornerRadius = model.cornerRadius.value
    }
    static func backgroundEffectView(_ view: UIVisualEffectView, model: VM) {
      view.setBackgroundStyle(
        model.backgroundStyle,
        backgroundColor: model.preferredBackgroundColor?.uiColor,
        borderColor: UniversalColor.divider.uiColor,
        borderWidth: model.borderWidth.value,
        cornerRadius: model.cornerRadius.value
      )
    }
    static func bodyWrapper(_ scrollView: UIScrollView) {
      scrollView.delaysContentTouches = false
      scrollView.contentInsetAdjustmentBehavior = .never
      scrollView.automaticallyAdjustsScrollIndicatorInsets = false
    }
  }
}
