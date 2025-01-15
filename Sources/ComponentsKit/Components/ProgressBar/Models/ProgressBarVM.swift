import SwiftUI

/// A model that defines the appearance properties for a a progress bar component.
public struct ProgressBarVM: ComponentVM {
  /// The color of the progress bar.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The visual style of the progress bar component.
  ///
  /// Defaults to `.striped`.
  public var style: Style = .striped

  /// The size of the progress bar.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The minimum value of the progress bar.
  public var minValue: CGFloat = 0

  /// The maximum value of the progress bar.
  public var maxValue: CGFloat = 100

  /// The corner radius of the progress bar.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// Initializes a new instance of `ProgressBarVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension ProgressBarVM {
  var backgroundHeight: CGFloat {
    switch self.style {
    case .light:
      switch size {
      case .small:
        return 4
      case .medium:
        return 8
      case .large:
        return 12
      }
    case .filled, .striped:
      switch self.size {
      case .small:
        return 20
      case .medium:
        return 32
      case .large:
        return 42
      }
    }
  }

  var progressHeight: CGFloat {
    return self.backgroundHeight - self.progressPadding * 2
  }

  func cornerRadius(for height: CGFloat) -> CGFloat {
    switch self.cornerRadius {
    case .none:
      return 0
    case .small:
      return height / 3.5
    case .medium:
      return height / 3.0
    case .large:
      return height / 2.5
    case .full:
      return height / 2.0
    case .custom(let value):
      return min(value, height / 2)
    }
  }

  var animationDuration: TimeInterval {
    return 0.2
  }

  var progressPadding: CGFloat {
    switch self.style {
    case .light:
      return 0
    case .filled, .striped:
      return 3
    }
  }

  var lightBarSpacing: CGFloat {
    return 4
  }

  var backgroundColor: UniversalColor {
    switch style {
    case .light:
      return self.color.background
    case .filled, .striped:
      return self.color.main
    }
  }

  var barColor: UniversalColor {
    switch style {
    case .light:
      return self.color.main
    case .filled, .striped:
      return self.color.contrast
    }
  }

  private func stripesCGPath(in rect: CGRect) -> CGMutablePath {
    let stripeWidth: CGFloat = 2
    let stripeSpacing: CGFloat = 4
    let stripeAngle: Angle = .degrees(135)

    let path = CGMutablePath()
    let step = stripeWidth + stripeSpacing
    let radians = stripeAngle.radians
    let dx = rect.height * tan(radians)
    for x in stride(from: dx, through: rect.width + rect.height, by: step) {
      let topLeft = CGPoint(x: x, y: 0)
      let topRight = CGPoint(x: x + stripeWidth, y: 0)
      let bottomLeft = CGPoint(x: x + dx, y: rect.height)
      let bottomRight = CGPoint(x: x + stripeWidth + dx, y: rect.height)
      path.move(to: topLeft)
      path.addLine(to: topRight)
      path.addLine(to: bottomRight)
      path.addLine(to: bottomLeft)
      path.closeSubpath()
    }
    return path
  }
}

extension ProgressBarVM {
  func progress(for currentValue: CGFloat) -> CGFloat {
    let range = self.maxValue - self.minValue
    guard range > 0 else { return 0 }
    let normalized = (currentValue - self.minValue) / range
    return max(0, min(1, normalized))
  }
}

// MARK: - UIKit Helpers

extension ProgressBarVM {
  func stripesBezierPath(in rect: CGRect) -> UIBezierPath {
    return UIBezierPath(cgPath: self.stripesCGPath(in: rect))
  }

  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.style != oldModel.style || self.size != oldModel.size
  }
}

// MARK: - SwiftUI Helpers

extension ProgressBarVM {
  func stripesPath(in rect: CGRect) -> Path {
    return Path(self.stripesCGPath(in: rect))
  }
}

// MARK: - Validation

extension ProgressBarVM {
  func validateMinMaxValues() {
    if self.minValue > self.maxValue {
      assertionFailure("Min value must be less than max value")
    }
  }
}
