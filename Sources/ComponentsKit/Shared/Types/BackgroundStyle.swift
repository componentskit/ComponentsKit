import Foundation

/// Defines how a component renders its background.
public enum BackgroundStyle: Sendable {
  /// A regular filled background using the component's configured background color.
  case solid
  /// A system liquid glass effect that lets underlying content show through the component.
  @available(iOS 26.0, *) case liquidGlass
  /// A system blur material that softens content behind the component.
  case blur
}
