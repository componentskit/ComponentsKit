import SwiftUI
import UIKit

/// Specifies the text string that displays in the Return key of a keyboard.
public enum SubmitType {
  /// Specifies that the title of the Return key is *Done*.
  case done
  /// Specifies that the title of the Return key is *Go*.
  case go
  /// Specifies that the title of the Return key is *Send*.
  case send
  /// Specifies that the title of the Return key is *Join*.
  case join
  /// Specifies that the title of the Return key is *Route*.
  case route
  /// Specifies that the title of the Return key is *Search*.
  case search
  /// Specifies that the title of the Return key is *Return*.
  case `return`
  /// Specifies that the title of the Return key is *Next*.
  case next
  /// Specifies that the title of the Return key is *Continue*.
  case `continue`
}

// MARK: - UIKit Helpers

extension SubmitType {
  public var returnKeyType: UIReturnKeyType {
    switch self {
    case .done:
      return .done
    case .go:
      return .go
    case .send:
      return .send
    case .join:
      return .join
    case .route:
      return .route
    case .search:
      return .search
    case .return:
      return .default
    case .next:
      return .next
    case .continue:
      return .continue
    }
  }
}

// MARK: - SwiftUI Helpers

extension SubmitType {
  public var submitLabel: SubmitLabel {
    switch self {
    case .done:
      return .done
    case .go:
      return .go
    case .send:
      return .send
    case .join:
      return .join
    case .route:
      return .route
    case .search:
      return .search
    case .return:
      return .return
    case .next:
      return .next
    case .continue:
      return .continue
    }
  }
}
