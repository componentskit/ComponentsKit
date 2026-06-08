import Foundation

/// A model that defines the data and appearance properties for an item in a segmented control.
public struct SegmentedControlItemVM<ID: Hashable & Sendable>: Updatable, Sendable {
  /// The unique identifier for the segmented control item.
  public var id: ID

  /// The text displayed for the segmented control item.
  public var title: String = ""

  /// The font used for the item's title.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the item is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// Initializes a new instance of `SegmentedControlItemVM` with the specified identifier.
  ///
  /// - Parameter id: The unique identifier for the segmented control item.
  public init(id: ID) {
    self.id = id
  }

  /// Initializes a new instance of `SegmentedControlItemVM` with a specified identifier and
  /// a closure for custom configuration.
  ///
  /// - Parameters:
  ///   - id: The unique identifier for the segmented control item.
  ///   - transform: A closure that allows for custom configuration of the model's properties.
  public init(id: ID, _ transform: (_ value: inout Self) -> Void) {
    var defaultValue = Self(id: id)
    transform(&defaultValue)
    self = defaultValue
  }
}

extension SegmentedControlItemVM: Equatable, Identifiable {}
