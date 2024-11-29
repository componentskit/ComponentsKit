import Foundation
import UIKit

/// A model that defines the appearance of a radio group component.
public struct RadioGroupVM<ID: Hashable>: ComponentVM {
  /// The scaling factor for the button's press animation, with a value between 0 and 1.
  ///
  /// Defaults to `.medium`.
  public var animationScale: AnimationScale = .medium

  /// The color of the selected radio button.
  public var color: UniversalColor = .primary

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
      return UniversalFont.Component.small
    case .medium:
      return UniversalFont.Component.medium
    case .large:
      return UniversalFont.Component.large
    }
  }

  func item(for id: ID) -> RadioItemVM<ID>? {
    return self.items.first(where: { $0.id == id })
  }
}

extension RadioGroupVM {
    func shouldUpdateLayout(_ oldModel: RadioGroupVM<ID>) -> Bool {
        return self.items != oldModel.items || self.size != oldModel.size
    }
}

// MARK: - Appearance

extension RadioGroupVM {
  func radioItemColor(for item: RadioItemVM<ID>, selectedId: ID?) -> UniversalColor {
    let isSelected = item.id == selectedId
    let defaultColor = UniversalColor.universal(.uiColor(.lightGray))
    let color = isSelected ? self.color : defaultColor
    return (item.isEnabled && self.isEnabled)
    ? color
    : color.withOpacity(ComponentsKitConfig.shared.layout.disabledOpacity)
  }

  func textColor(for item: RadioItemVM<ID>, selectedId: ID?) -> UniversalColor {
    let baseColor = Palette.Text.primary
    return (item.isEnabled && self.isEnabled)
    ? baseColor
    : baseColor.withOpacity(ComponentsKitConfig.shared.layout.disabledOpacity)
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
