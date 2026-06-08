import UIKit

extension UIVisualEffectView {
  func setBackgroundStyle(
    _ backgroundStyle: BackgroundStyle,
    backgroundColor: UIColor?,
    borderColor: UIColor?,
    borderWidth: CGFloat,
    cornerRadius: CGFloat,
    isGlassInteractive: Bool = true
  ) {
    self.contentView.layer.cornerRadius = cornerRadius
    self.layer.cornerRadius = cornerRadius
    self.layer.borderColor = borderColor?.cgColor
    self.layer.borderWidth = borderWidth
    self.clipsToBounds = true

    switch backgroundStyle {
    case .solid:
      self.effect = nil
      self.backgroundColor = backgroundColor
    case .blur:
      self.effect = UIBlurEffect(style: .systemThinMaterial)
      self.backgroundColor = backgroundColor
    case .liquidGlass:
      if #available(iOS 26.0, *) {
        let effect = UIGlassEffect(style: .regular)
        effect.tintColor = backgroundColor
        effect.isInteractive = isGlassInteractive
        self.effect = effect
        self.backgroundColor = nil
      } else {
        self.effect = nil
        self.backgroundColor = backgroundColor
      }
    }
  }
}
