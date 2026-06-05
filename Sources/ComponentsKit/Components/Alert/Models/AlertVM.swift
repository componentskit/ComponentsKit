import Foundation

/// A model that defines the appearance properties for an alert.
public struct AlertVM: ComponentVM {
  /// The title of the alert.
  public var title: String?

  /// The message of the alert.
  public var message: String?

  /// The model that defines the appearance properties for a primary button in the alert.
  ///
  /// If it is `nil`, the primary button will not be displayed.
  public var primaryButton: AlertButtonVM?

  /// The model that defines the appearance properties for a secondary button in the alert.
  ///
  /// If it is `nil`, the secondary button will not be displayed.
  public var secondaryButton: AlertButtonVM?

  /// The background color of the alert.
  public var backgroundColor: UniversalColor?

  /// Defines how the alert renders its background.
  public var backgroundStyle: BackgroundStyle = .solid

  /// The border thickness of the alert.
  ///
  /// Defaults to `.small`.
  public var borderWidth: BorderWidth = .small

  /// A Boolean value indicating whether the alert should close when tapping on the overlay.
  ///
  /// Defaults to `false`.
  public var closesOnOverlayTap: Bool = false

  /// The padding applied to the alert's content area.
  ///
  /// Defaults to a padding value of `16` for all sides.
  public var contentPaddings: Paddings = .init(padding: 16)

  /// The corner radius of the alert.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ContainerRadius = .medium

  /// The style of the overlay displayed behind the alert.
  ///
  /// Defaults to `.dimmed`.
  public var overlayStyle: ModalOverlayStyle = .dimmed

  /// The transition duration of the alert's appearance and dismissal animations.
  ///
  /// Defaults to `.fast`.
  public var transition: ModalTransition = .fast

  /// Initializes a new instance of `AlertVM` with default values.
  public init() {}
}

// MARK: - Helpers

extension AlertVM {
  var modalVM: CenterModalVM {
    return CenterModalVM {
      $0.backgroundColor = self.backgroundColor
      $0.backgroundStyle = self.backgroundStyle
      $0.borderWidth = self.borderWidth
      $0.closesOnOverlayTap = self.closesOnOverlayTap
      $0.contentPaddings = self.contentPaddings
      $0.cornerRadius = self.cornerRadius
      $0.overlayStyle = self.overlayStyle
      $0.transition = self.transition
      $0.size = .small
    }
  }

  var primaryButtonVM: ButtonVM? {
    let buttonVM = self.primaryButton.map(self.mapAlertButtonVM)
    if self.secondaryButton.isNotNil {
      return buttonVM
    } else {
      return buttonVM ?? Self.defaultButtonVM
    }
  }

  var secondaryButtonVM: ButtonVM? {
    return self.secondaryButton.map(self.mapAlertButtonVM)
  }

  private func mapAlertButtonVM(_ model: AlertButtonVM) -> ButtonVM {
    return ButtonVM {
      $0.title = model.title
      $0.animationScale = model.animationScale
      $0.color = model.color
      $0.cornerRadius = model.cornerRadius
      $0.style = model.style
      $0.isFullWidth = true
    }
  }
}

extension AlertVM {
  static let buttonsSpacing: CGFloat = 12

  static let defaultButtonVM = ButtonVM {
    $0.title = "OK"
    $0.color = .primary
    $0.style = .filled
    $0.isFullWidth = true
  }
}
