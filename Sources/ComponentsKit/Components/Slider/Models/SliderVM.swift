import SwiftUI

/// A model that defines the appearance properties for a slider component.
public struct SliderVM: ComponentVM {
  /// The color of the slider.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The visual style of the slider component.
  ///
  /// Defaults to `.light`.
  public var style: Style = .light

  /// The size of the slider.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The minimum value of the slider.
  public var minValue: CGFloat = 0

  /// The maximum value of the slider.
  public var maxValue: CGFloat = 100

  /// The corner radius of the slider track and handle.
  ///
  /// Defaults to `.full`.
  public var cornerRadius: ComponentRadius = .full

  /// The step value for the slider.
  ///
  /// Defaults to `1`.
  public var step: CGFloat = 1

  /// Initializes a new instance of `SliderVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension SliderVM {
  var trackHeight: CGFloat {
    switch self.size {
    case .small:
      return 6
    case .medium:
      return 12
    case .large:
      return 32
    }
  }
  var handleSize: CGSize {
    switch self.size {
    case .small, .medium:
      return CGSize(width: 20, height: 32)
    case .large:
      return CGSize(width: 40, height: 40)
    }
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
  var trackSpacing: CGFloat {
    return 4
  }
  var handleOverlaySide: CGFloat {
    12
  }
  var backgroundColor: UniversalColor {
    switch style {
    case .light:
      return self.color.background
    case .striped:
      return self.color.main
    }
  }
  var barColor: UniversalColor {
    switch style {
    case .light:
      return self.color.main
    case .striped:
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

    for x in stride(from: rect.width + rect.height, through: dx, by: -step) {
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

extension SliderVM {
  func steppedValue(for offset: CGFloat, trackWidth: CGFloat) -> CGFloat {
    guard trackWidth > 0 else { return self.minValue }

    let newProgress = offset / trackWidth

    let newValue = self.minValue + newProgress * (self.maxValue - self.minValue)

    if self.step > 0 {
      let stepsCount = (newValue / self.step).rounded()
      return stepsCount * self.step
    } else {
      return newValue
    }
  }
}

extension SliderVM {
  func progress(for currentValue: CGFloat) -> CGFloat {
    let range = self.maxValue - self.minValue
    guard range > 0 else { return 0 }
    let normalized = (currentValue - self.minValue) / range
    return max(0, min(1, normalized))
  }
}

public extension SliderVM {
  var sliderHeight: CGFloat {
    self.trackHeight
  }

  var containerHeight: CGFloat {
    max(self.handleSize.height, self.trackHeight)
  }

  func leftWidth(for totalWidth: CGFloat, progress: CGFloat) -> CGFloat {
    let sliderWidth = max(0, totalWidth - self.handleSize.width - 2 * self.trackSpacing)
    return sliderWidth * progress
  }

  func rightWidth(for totalWidth: CGFloat, progress: CGFloat) -> CGFloat {
    let sliderWidth = max(0, totalWidth - self.handleSize.width - 2 * self.trackSpacing)
    return sliderWidth - self.leftWidth(for: totalWidth, progress: progress)
  }

  func barWidth(for totalWidth: CGFloat, progress: CGFloat) -> CGFloat {
    self.leftWidth(for: totalWidth, progress: progress)
  }

  func backgroundWidth(for totalWidth: CGFloat, progress: CGFloat) -> CGFloat {
    self.rightWidth(for: totalWidth, progress: progress)
  }
}

// MARK: - UIKit Helpers

extension SliderVM {
  func stripesBezierPath(in rect: CGRect) -> UIBezierPath {
    return UIBezierPath(cgPath: self.stripesCGPath(in: rect))
  }

  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.style != oldModel.style ||
    self.size != oldModel.size ||
    self.step != oldModel.step
  }
}

// MARK: - SwiftUI Helpers

extension SliderVM {
  func stripesPath(in rect: CGRect) -> Path {
    Path(self.stripesCGPath(in: rect))
  }
}

// MARK: - Validation

extension SliderVM {
  func validateMinMaxValues() {
    if self.minValue > self.maxValue {
      assertionFailure("Min value must be less than max value")
    }
  }
}
