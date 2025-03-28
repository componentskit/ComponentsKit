import Combine
import Foundation

extension NSObject {
  /// Observes changes to the `.current` theme and updates dependent views.
  ///
  /// This method allows you to respond to theme changes by updating view properties that depend on the theme.
  ///
  /// You can invoke the ``observeThemeChange(_:)`` method a single time in the `viewDidLoad`
  /// and update all the view elements:
  ///
  /// ```swift
  /// override func viewDidLoad() {
  ///   super.viewDidLoad()
  ///
  ///   style()
  ///
  ///   observeThemeChanges { [weak self] in
  ///     guard let self else { return }
  ///
  ///     self.style()
  ///   }
  /// }
  ///
  /// func style() {
  ///   view.backgroundColor = UniversalColor.background.uiColor
  ///   button.model = ButtonVM {
  ///     $0.title = "Tap me"
  ///     $0.color = .accent
  ///   }
  ///   // ...
  /// }
  /// ```
  ///
  /// ## Cancellation
  ///
  /// The method returns an ``AnyCancellable`` that can be used to cancel observation. For
  /// example, if you only want to observe while a view controller is visible, you can start
  /// observation in the `viewWillAppear` and then cancel observation in the `viewWillDisappear`:
  ///
  /// ```swift
  /// var cancellable: AnyCancellable?
  ///
  /// func viewWillAppear() {
  ///   super.viewWillAppear()
  ///   cancellable = observeThemeChange { [weak self] in
  ///     // ...
  ///   }
  /// }
  /// func viewWillDisappear() {
  ///   super.viewWillDisappear()
  ///   cancellable?.cancel()
  /// }
  /// ```
  ///
  /// - Parameter apply: A closure that will be called whenever the `.current` theme changes.
  ///   This should contain logic to update theme-dependent views.
  /// - Returns: An `AnyCancellable` instance that can be used to stop observing the theme changes when needed.
  @discardableResult
  public func observeThemeChange(_ apply: @escaping () -> Void) -> AnyCancellable {
    let cancellable = NotificationCenter.default.publisher(
      for: Theme.didChangeThemeNotification
    )
      .receive(on: DispatchQueue.main)
      .sink { _ in
        apply()
      }
    self.cancellables.append(cancellable)
    return cancellable
  }

  fileprivate var cancellables: [Any] {
    get {
      objc_getAssociatedObject(self, Self.cancellablesKey) as? [Any] ?? []
    }
    set {
      objc_setAssociatedObject(self, Self.cancellablesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  private static let cancellablesKey = "themeChangeObserverCancellables"
}
