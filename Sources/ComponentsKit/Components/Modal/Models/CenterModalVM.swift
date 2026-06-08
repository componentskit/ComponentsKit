import Foundation

/// A model that defines the appearance properties for a center modal component.
public struct CenterModalVM: ModalVM {
  /// The background color of the modal.
  public var backgroundColor: UniversalColor?

  /// Defines how modal renders its background.
  public var backgroundStyle: BackgroundStyle = .solid

  /// The border thickness of the modal.
  ///
  /// Defaults to `.small`.
  public var borderWidth: BorderWidth = .small

  /// A Boolean value indicating whether the modal should close when tapping on the overlay.
  ///
  /// Defaults to `true`.
  public var closesOnOverlayTap: Bool = true

  /// The padding applied to the modal's content area.
  ///
  /// Defaults to a padding value of `16` for all sides.
  public var contentPaddings: Paddings = .init(padding: 16)

  /// The spacing between header, body and footer.
  public var contentSpacing: CGFloat = 16

  /// The corner radius of the modal.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ContainerRadius = .medium

  /// The style of the overlay displayed behind the modal.
  ///
  /// Defaults to `.dimmed`.
  public var overlayStyle: ModalOverlayStyle = .dimmed

  /// The padding applied outside the modal's content area, creating space between the modal and the screen edges.
  ///
  /// Defaults to a padding value of `20` for all sides.
  public var outerPaddings: Paddings = .init(padding: 20)

  /// The predefined maximum size of the modal.
  ///
  /// Defaults to `.medium`.
  public var size: ModalSize = .medium

  /// The transition duration of the modal's appearance and dismissal animations.
  ///
  /// Defaults to `.fast`.
  public var transition: ModalTransition = .fast

  /// Initializes a new instance of `CenterModalVM` with default values.
  public init() {}
}
