import UIKit

/// A protocol that defines a UIKit component with a configurable model.
///
/// Types conforming to `UKComponent` are responsible for updating their appearance
/// based on changes to their associated model.
public protocol UKComponent: UIView {
  /// A type of the model that defines the appearance properties.
  associatedtype Model

  /// A model that defines the appearance properties.
  var model: Model { get set }

  /// Updates the component when the model changes.
  ///
  /// This method is called when the `model` property changes, providing an opportunity
  /// to compare the new and old models and update the component's appearance.
  ///
  /// - Parameter oldModel: The previous model before the update.
  func update(_ oldModel: Model)
}
