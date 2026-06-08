import UIKit

@MainActor
struct CountdownWidthCalculator {
  private init() {}

  static func preferredWidth(
    for attributedText: NSAttributedString,
    model: CountdownVM
  ) -> CGFloat {
    let label = UILabel()
    self.style(label, with: model)
    label.attributedText = attributedText

    let estimatedSize = label.sizeThatFits(UIView.layoutFittingExpandedSize)

    return estimatedSize.width + 2
  }

  private static func style(_ label: UILabel, with model: CountdownVM) {
    label.textAlignment = .center
    label.numberOfLines = 0
  }
}
