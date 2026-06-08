import Foundation

/// A model that defines the appearance properties for a button in the alert.
public struct AlertButtonVM: ComponentVM {
  /// The text displayed on the button.
  public var title: String = ""

  /// The scaling factor for the button's press animation, with a value between 0 and 1.
  ///
  /// Defaults to `.medium`.
  public var animationScale: AnimationScale = .medium

  /// Defines how the button renders its background.
  ///
  /// Defaults to `.solid`.
  public var backgroundStyle: BackgroundStyle = .solid

  /// The color of the button.
  public var color: ComponentColor?

  /// The corner radius of the button.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The visual style of the button.
  ///
  /// Defaults to `.filled`.
  public var style: ButtonStyle = .filled

  /// Initializes a new instance of `AlertButtonVM` with default values.
  public init() {}
}
