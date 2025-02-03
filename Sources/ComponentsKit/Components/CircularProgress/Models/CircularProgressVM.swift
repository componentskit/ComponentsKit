import SwiftUI

/// A model that defines the appearance properties for a circular progress component.
public struct CircularProgressVM: ComponentVM {
  /// The color of the circular progress.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The style of the circular progress indicator.
  ///
  /// Defaults to `.light`.
  public var style: Style = .light

  /// The  size of the circular progress.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The minimum value of the circular progress.
  ///
  /// Defaults to `0`.
  public var minValue: CGFloat = 0

  /// The maximum value of the circular progress.
  ///
  /// Defaults to `100`.
  public var maxValue: CGFloat = 100

  /// The width of the circular progress stroke.
  public var lineWidth: CGFloat?

  /// An optional label to display inside the circular progress.
  public var label: String?

  /// The font used for the circular progress label text.
  public var font: UniversalFont?

  /// Initializes a new instance of `CircularProgressVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension CircularProgressVM {
  var animationDuration: TimeInterval {
    return 0.2
  }
  var circularLineWidth: CGFloat {
    return self.lineWidth ?? max(self.preferredSize.width / 8, 2)
  }
  var preferredSize: CGSize {
    switch self.size {
    case .small:
      return CGSize(width: 48, height: 48)
    case .medium:
      return CGSize(width: 64, height: 64)
    case .large:
      return CGSize(width: 80, height: 80)
    }
  }
  var radius: CGFloat {
    return self.preferredSize.height / 2 - self.circularLineWidth / 2
  }
  var center: CGPoint {
    return .init(
      x: self.preferredSize.width / 2,
      y: self.preferredSize.height / 2
    )
  }
  var titleFont: UniversalFont {
    if let font {
      return font
    }
    switch self.size {
    case .small:
      return .smCaption
    case .medium:
      return .mdCaption
    case .large:
      return .lgCaption
    }
  }
  private func stripesCGPath(in rect: CGRect) -> CGMutablePath {
    let stripeWidth: CGFloat = 0.5
    let stripeSpacing: CGFloat = 3
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

extension CircularProgressVM {
  func gap(for normalized: CGFloat) -> CGFloat {
    normalized > 0 ? 0.05 : 0
  }

  func progressArcStart(for normalized: CGFloat) -> CGFloat {
    return 0
  }

  func progressArcEnd(for normalized: CGFloat) -> CGFloat {
    return max(0, min(1, normalized))
  }

  func backgroundArcStart(for normalized: CGFloat) -> CGFloat {
    let gapValue = self.gap(for: normalized)
    return max(0, min(1, normalized + gapValue))
  }

  func backgroundArcEnd(for normalized: CGFloat) -> CGFloat {
    let gapValue = self.gap(for: normalized)
    return 1 - gapValue
  }
}

extension CircularProgressVM {
  public func progress(for currentValue: CGFloat) -> CGFloat {
    let range = self.maxValue - self.minValue
    guard range > 0 else { return 0 }
    let normalized = (currentValue - self.minValue) / range
    return max(0, min(1, normalized))
  }
}

// MARK: - SwiftUI Helpers

extension CircularProgressVM {
  func stripesPath(in rect: CGRect) -> Path {
    Path(self.stripesCGPath(in: rect))
  }
}
