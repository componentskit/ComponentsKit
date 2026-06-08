import UIKit

@MainActor
struct AlertButtonsOrientationCalculator {
  enum Orientation {
    case vertical
    case horizontal
  }

  private init() {}

  static func preferredOrientation(model: AlertVM) -> Orientation {
    guard let primaryButtonVM = model.primaryButtonVM,
          let secondaryButtonVM = model.secondaryButtonVM else {
      return .vertical
    }

    let primaryButton = UKButton(model: primaryButtonVM.updating {
      $0.isFullWidth = false
    })
    let secondaryButton = UKButton(model: secondaryButtonVM.updating {
      $0.isFullWidth = false
    })

    let primaryButtonWidth = primaryButton.intrinsicContentSize.width
    let secondaryButtonWidth = secondaryButton.intrinsicContentSize.width

    // Since the `maxWidth` of the alert is always less than the width of the
    // screen, we can assume that the width of the container is equal to this
    // `maxWidth` value.
    let containerWidth = model.modalVM.size.maxWidth
    let availableButtonsWidth = containerWidth
    - AlertVM.buttonsSpacing
    - model.contentPaddings.leading
    - model.contentPaddings.trailing
    let availableButtonWidth = availableButtonsWidth / 2

    if primaryButtonWidth <= availableButtonWidth,
       secondaryButtonWidth <= availableButtonWidth {
      return .horizontal
    } else {
      return .vertical
    }
  }
}
