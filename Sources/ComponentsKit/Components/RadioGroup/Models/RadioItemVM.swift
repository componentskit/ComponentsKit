import Foundation

/// A model that defines the data and appearance properties for an item in a radio group.
public struct RadioItemVM<ID: Hashable & Sendable>: Sendable {
  /// The unique identifier for the radio item.
  public var id: ID

  /// The text displayed next to the radio button.
  public var title: String = ""

  /// The font used for the item's title.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the item is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// Initializes a new instance of `RadioItemVM` with the specified identifier.
  ///
  /// - Parameter id: The unique identifier for the radio item.
  public init(id: ID) {
    self.id = id
  }

  /// Initializes a new instance of `RadioItemVM` with a closure for custom configuration.
  ///
  /// - Parameters:
  ///   - id: The unique identifier for the radio item.
  ///   - transform: A closure that allows for custom configuration of the model's properties.
  public init(id: ID, _ transform: (_ value: inout Self) -> Void) {
    var defaultValue = Self(id: id)
    transform(&defaultValue)
    self = defaultValue
  }
}

extension RadioItemVM: Equatable, Identifiable {}
