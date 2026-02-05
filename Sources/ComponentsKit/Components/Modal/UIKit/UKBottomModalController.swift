import UIKit

/// A bottom-aligned modal controller.
///
/// - Example:
/// ```swift
/// let bottomModal = UKBottomModalController(
///   model: BottomModalVM(),
///   header: { _ in
///     let headerLabel = UILabel()
///     headerLabel.text = "Header"
///     return headerLabel
///   },
///   body: { _ in
///     let bodyLabel = UILabel()
///     bodyLabel.text = "This is the body content of the modal."
///     bodyLabel.numberOfLines = 0
///     return bodyLabel
///   },
///   footer: { dismiss in
///     return UKButton(model: .init {
///       $0.title = "Close"
///     }) {
///       dismiss(true)
///     }
///   }
/// )
///
/// vc.present(bottomModal, animated: true)
/// ```
public class UKBottomModalController: UKModalController<BottomModalVM> {
  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - header: An optional content block for the modal's header.
  ///   - body: The main content block for the modal.
  ///   - footer: An optional content block for the modal's footer.
  public init(
    model: BottomModalVM = .init(),
    header: Content? = nil,
    body: Content,
    footer: Content? = nil
  ) {
    super.init(model: model)

    self.header = header?({ [weak self] animated in
      self?.dismiss(animated: animated)
    })
    self.body = body({ [weak self] animated in
      self?.dismiss(animated: animated)
    })
    self.footer = footer?({ [weak self] animated in
      self?.dismiss(animated: animated)
    })
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.contentView.transform = .init(translationX: 0, y: self.view.screenBounds.height)
    self.overlay.alpha = 0
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animate(withDuration: self.model.transition.value) {
      self.contentView.transform = .identity
      self.overlay.alpha = 1
    }
  }

  // MARK: - Setup

  public override func setup() {
    super.setup()

    self.contentView.addGestureRecognizer(UIPanGestureRecognizer(
      target: self,
      action: #selector(self.handleDragGesture)
    ))
  }

  // MARK: - Layout

  public override func layout() {
    super.layout()

    self.contentViewBottomConstraint = self.contentView.bottom(self.model.outerPaddings.bottom, safeArea: true).bottom
  }

  // MARK: - UIViewController Methods

  public override func dismiss(
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    UIView.animate(withDuration: self.model.transition.value) {
      self.contentView.transform = .init(translationX: 0, y: self.view.screenBounds.height)
      self.overlay.alpha = 0
    } completion: { _ in
      super.dismiss(animated: false)
    }
  }
}

// MARK: - Interactions

extension UKBottomModalController {
  @objc private func handleDragGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.contentView).y
    let velocity = gesture.velocity(in: self.contentView).y
    let offset = ModalAnimation.bottomModalOffset(translation, model: self.model)

    switch gesture.state {
    case .changed:
      self.contentView.transform = .init(translationX: 0, y: offset)
    case .ended:
      let viewHeight = self.contentView.frame.height
      if ModalAnimation.shouldHideBottomModal(offset: offset, height: viewHeight, velocity: velocity, model: self.model) {
        self.dismiss(animated: true)
      } else {
        UIView.animate(withDuration: 0.2) {
          self.contentView.transform = .identity
        }
      }
    case .failed, .cancelled:
      UIView.animate(withDuration: 0.2) {
        self.contentView.transform = .identity
      }
    default:
      break
    }
  }
}

// MARK: - UIViewController + Present Bottom Modal

extension UIViewController {
  public func present(
    _ vc: UKBottomModalController,
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    self.present(vc as UIViewController, animated: false, completion: completion)
  }
}
