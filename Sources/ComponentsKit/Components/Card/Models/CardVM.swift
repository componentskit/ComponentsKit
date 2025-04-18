import Foundation

/// A model that defines the appearance properties for a card component.
public struct CardVM: ComponentVM {
  /// The scaling factor for the card's tap animation, with a value between 0 and 1.
  ///
  /// Defaults to `.medium`.
  public var animationScale: AnimationScale = .medium

  /// The background color of the card.
  public var backgroundColor: UniversalColor = .background

  /// The border color of the card.
  public var borderColor: UniversalColor = .divider

  /// The border thickness of the card.
  ///
  /// Defaults to `.medium`.
  public var borderWidth: BorderWidth = .medium

  /// The padding applied to the card's content area.
  ///
  /// Defaults to a padding value of `16` for all sides.
  public var contentPaddings: Paddings = .init(padding: 16)

  /// The corner radius of the card.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ContainerRadius = .medium

  /// A Boolean value indicating whether the card should allow to be tapped.
  ///
  /// Defaults to `true`.
  public var isTappable: Bool = false

  /// The shadow of the card.
  ///
  /// Defaults to `.medium`.
  public var shadow: Shadow = .medium

  /// Initializes a new instance of `CardVM` with default values.
  public init() {}
}
