import Foundation
import UIKit

/// A model that defines the data and appearance properties for a radio group component.
public struct RadioGroupVM<ID: Hashable & Sendable>: ComponentVM {
  /// The scaling factor for the button's press animation, with a value between 0 and 1.
  ///
  /// Defaults to `.medium`.
  public var animationScale: AnimationScale = .medium

  /// The color of the selected radio button.
  public var color: UniversalColor = .accent

  /// The font used for the radio items' titles.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the radio group is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// An array of items representing the options in the radio group.
  ///
  /// Must contain at least one item, and all items must have unique identifiers.
  public var items: [RadioItemVM<ID>] = [] {
    didSet {
      guard self.items.isNotEmpty else {
        assertionFailure("Array of items must contain at least one item.")
        return
      }
      if let duplicatedId {
        assertionFailure("Items must have unique ids! Duplicated id: \(duplicatedId)")
      }
    }
  }

  /// The predefined size of the radio buttons.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The spacing between radio items.
  ///
  /// Defaults to `10`.
  public var spacing: CGFloat = 10

  /// Initializes a new instance of `RadioGroupVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension RadioGroupVM {
  var circleSize: CGFloat {
    switch self.size {
    case .small:
      return 16
    case .medium:
      return 20
    case .large:
      return 24
    }
  }

  var innerCircleSize: CGFloat {
    switch self.size {
    case .small:
      return 10
    case .medium:
      return 12
    case .large:
      return 14
    }
  }

  var lineWidth: CGFloat {
    switch self.size {
    case .small:
      return 1.5
    case .medium:
      return 2.0
    case .large:
      return 2.0
    }
  }

  func preferredFont(for id: ID) -> UniversalFont {
    if let itemFont = self.item(for: id)?.font {
      return itemFont
    } else if let font = self.font {
      return font
    }

    switch self.size {
    case .small:
      return .smBody
    case .medium:
      return .mdBody
    case .large:
      return .lgBody
    }
  }

  func item(for id: ID) -> RadioItemVM<ID>? {
    return self.items.first(where: { $0.id == id })
  }
}

// MARK: - Appearance

extension RadioGroupVM {
  func isItemEnabled(_ item: RadioItemVM<ID>) -> Bool {
    return item.isEnabled && self.isEnabled
  }

  func radioItemColor(for item: RadioItemVM<ID>, isSelected: Bool) -> UniversalColor {
    if isSelected {
      return self.color.enabled(self.isItemEnabled(item))
    } else {
      return .divider
    }
  }

  func textColor(for item: RadioItemVM<ID>) -> UniversalColor {
    return .foreground.enabled(self.isItemEnabled(item))
  }
}

// MARK: - UIKit Helpers

extension RadioGroupVM {
  func shouldUpdateLayout(_ oldModel: RadioGroupVM<ID>) -> Bool {
    return self.items != oldModel.items || self.size != oldModel.size
  }
}

// MARK: - Validation

extension RadioGroupVM {
  /// Checks for duplicated item identifiers in the radio group.
  private var duplicatedId: ID? {
    var set: Set<ID> = []
    for item in self.items {
      if set.contains(item.id) {
        return item.id
      }
      set.insert(item.id)
    }
    return nil
  }
}
