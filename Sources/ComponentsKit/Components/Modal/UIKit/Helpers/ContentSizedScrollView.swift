import UIKit

/// A custom `UIScrollView` subclass that automatically adjusts its intrinsic content size
/// based on its content size, ensuring it fits its content vertically.
final class ContentSizedScrollView: UIScrollView {
  override var contentSize: CGSize {
    didSet {
      self.invalidateIntrinsicContentSize()
    }
  }

  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return CGSize(
      width: UIView.noIntrinsicMetric,
      height: self.contentSize.height
    )
  }
}
