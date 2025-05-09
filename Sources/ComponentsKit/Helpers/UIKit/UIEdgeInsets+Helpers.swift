import UIKit

extension UIEdgeInsets {
  /// Creates an instance of `UIEdgeInsets` with equal insets.
  init(inset: CGFloat) {
    self.init(top: inset, left: inset, bottom: inset, right: inset)
  }
}
