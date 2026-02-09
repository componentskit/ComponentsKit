import UIKit

/// A model that defines the appearance properties for an avatar in the group.
public struct AvatarItemVM: ComponentVM {
  /// The source of the image to be displayed.
  public var imageSrc: AvatarVM.ImageSource?

  /// The placeholder that is displayed if the image is not provided or fails to load.
  public var placeholder: AvatarVM.Placeholder = .image(.init("avatar_placeholder", bundle: .module))

  /// Initializes a new instance of `AvatarItemVM` with default values.
  public init() {}
}
