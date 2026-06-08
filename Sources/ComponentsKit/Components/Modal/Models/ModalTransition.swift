import Foundation

/// Defines the transition speed options for a modal's appearance and dismissal animations.
public enum ModalTransition: Hashable, Sendable {
  /// No transition is applied; the modal appears and disappears instantly.
  case none
  /// A slow transition speed.
  case slow
  /// A normal transition speed.
  case normal
  /// A fast transition speed.
  case fast
  /// A custom transition speed defined by a specific time interval.
  ///
  /// - Parameter duration: The duration of the custom transition in seconds.
  case custom(TimeInterval)
}

extension ModalTransition {
  var value: TimeInterval {
    switch self {
    case .none:
      return 0.0
    case .slow:
      return 0.5
    case .normal:
      return 0.3
    case .fast:
      return 0.2
    case .custom(let value):
      return max(0, value)
    }
  }
}
