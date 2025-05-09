/// A type whose values can be updated or can create and updated copy.
public protocol Updatable {
  /// Returns a new instance by applying a transformation to a copy of the current instance.
  ///
  /// - Parameter transform: A closure that defines the transformation.
  /// - Returns: A new instance with the changes applied.
  func updating(_ transform: (_ value: inout Self) -> Void) -> Self

  /// Modifies the current instance by applying a transformation closure.
  ///
  /// - Parameter transform: A closure that defines the transformation.
  mutating func update(_ transform: (_ value: inout Self) -> Void)
}

extension Updatable {
  /// Returns a new instance by applying a transformation to a copy of the current instance.
  ///
  /// This default implementation makes a copy of the current instance, applies the transformation closure to the copy, and returns the updated copy.
  ///
  /// - Parameter transform: A closure that defines the transformation.
  /// - Returns: A new instance with the changes applied.
  public func updating(_ transform: (_ value: inout Self) -> Void) -> Self {
    var copy = self
    transform(&copy)
    return copy
  }

  /// Modifies the current instance by applying a transformation closure.
  ///
  /// This default implementation applies the transformation closure to the current instance.
  ///
  /// - Parameter transform: A closure that defines the transformation.
  public mutating func update(_ transform: (_ value: inout Self) -> Void) {
    transform(&self)
  }
}
