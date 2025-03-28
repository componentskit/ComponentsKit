import SwiftUI
import UIKit

/// A model that defines the appearance properties for a segmented control component.
public struct SegmentedControlVM<ID: Hashable>: ComponentVM {
  /// The color of the segmented control.
  public var color: ComponentColor?

  /// The corner radius of the segmented control.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the segmented control items' titles.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the segmented control is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// A Boolean value indicating whether the segmented control should take the full width of its superview.
  ///
  /// Defaults to `false`.
  public var isFullWidth: Bool = false

  /// The array of items in the segmented control.
  ///
  /// It must contain at least one item and all items must have unique identifiers.
  public var items: [SegmentedControlItemVM<ID>] = [] {
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

  /// The predefined size of the segmented control.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `SegmentedControlVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension SegmentedControlVM {
  var backgroundColor: UniversalColor {
    return .content1
  }
  var selectedSegmentColor: UniversalColor {
    let color = self.color?.main ?? .themed(
      light: UniversalColor.background.light,
      dark: UniversalColor.content2.dark
    )
    return color.enabled(self.isEnabled)
  }
  func item(for id: ID) -> SegmentedControlItemVM<ID>? {
    return self.items.first(where: { $0.id == id })
  }
  func foregroundColor(id: ID, selectedId: ID) -> UniversalColor {
    let isItemEnabled = self.item(for: id)?.isEnabled == true
    let isSelected = id == selectedId && isItemEnabled

    let color = isSelected
    ? self.color?.contrast ?? .foreground
    : .secondaryForeground
    return color.enabled(self.isEnabled && isItemEnabled)
  }
  var horizontalInnerPaddings: CGFloat? {
    guard !self.isFullWidth else {
      return 0
    }
    return switch self.size {
    case .small: 8
    case .medium: 12
    case .large: 16
    }
  }
  var outerPaddings: CGFloat {
    return 4
  }
  var width: CGFloat? {
    return self.isFullWidth ? 10_000 : nil
  }
  var height: CGFloat {
    return switch self.size {
    case .small: 36
    case .medium: 44
    case .large: 52
    }
  }
  func selectedSegmentCornerRadius(for height: CGFloat = 10_000) -> CGFloat {
    let componentRadius = self.cornerRadius.value(for: height)
    switch self.cornerRadius {
    case .none, .full, .custom:
      return componentRadius
    case .small, .medium, .large:
      return max(0, componentRadius - self.outerPaddings)
    }
  }
  func preferredFont(for id: ID) -> UniversalFont {
    if let itemFont = self.item(for: id)?.font {
      return itemFont
    } else if let font {
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
}

// MARK: - UIKit Helpers

extension SegmentedControlVM {
  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.items != oldModel.items
    || self.size != oldModel.size
    || self.isFullWidth != oldModel.isFullWidth
    || self.font != oldModel.font
  }
}

// MARK: - Validation

extension SegmentedControlVM {
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
