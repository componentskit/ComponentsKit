import SwiftUI

/// A SwiftUI wrapper that listens for theme changes and automatically refreshes its content.
///
/// `ThemeChangeObserver` ensures that its child views **rebuild** whenever the theme changes,
/// helping to apply updated theme styles dynamically.
///
/// ## Usage
///
/// Wrap your view inside `ThemeChangeObserver` to make it responsive to theme updates:
///
/// ```swift
/// @main
/// struct Root: App {
///   var body: some Scene {
///     WindowGroup {
///       ThemeChangeObserver {
///         Content()
///       }
///     }
///   }
/// }
/// ```
///
/// ## Performance Considerations
///
/// - This approach forces a **full re-evaluation** of the wrapped content, which ensures all theme-dependent
///   properties are updated.
/// - Use it **at a high level** in your SwiftUI hierarchy (e.g., wrapping entire screens) rather than for small components.
public struct ThemeChangeObserver<Content: View>: View {
  @State private var themeId = UUID()
  @ViewBuilder var content: () -> Content

  public init(content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    self.content()
      .onReceive(NotificationCenter.default.publisher(
        for: Theme.didChangeThemeNotification,
        object: nil
      )) { _ in
        self.themeId = UUID()
      }
      .id(self.themeId)
  }
}
