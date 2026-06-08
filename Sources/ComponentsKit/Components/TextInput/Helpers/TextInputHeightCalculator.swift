import UIKit

@MainActor
struct TextInputHeightCalculator {
  private init() {}

  static func preferredHeight(
    for text: String,
    model: TextInputVM,
    width: CGFloat
  ) -> CGFloat {
    let textView = UITextView()
    textView.text = text
    self.style(textView, with: model)

    let targetSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let estimatedHeight = textView.sizeThatFits(targetSize).height

    return estimatedHeight
  }

  private static func style(_ textView: UITextView, with model: TextInputVM) {
    textView.isScrollEnabled = false
    textView.font = model.preferredFont.uiFont
    textView.textContainerInset = .init(inset: model.contentPadding)
    textView.textContainer.lineFragmentPadding = 0
  }
}
