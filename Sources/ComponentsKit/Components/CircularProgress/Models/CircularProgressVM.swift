import SwiftUI

/// A model that defines the appearance properties for a circular progress component.
public struct CircularProgressVM: ComponentVM {
  /// The color of the circular progress.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The current value of the circular progress.
  ///
  /// Defaults to `0`.
  public var currentValue: CGFloat = 0

  /// The font used for the circular progress label text.
  public var font: UniversalFont?

  /// An optional label to display inside the circular progress.
  public var label: String?

  /// The style of line endings.
  public var lineCap: LineCap = .rounded

  /// The width of the circular progress stroke.
  public var lineWidth: CGFloat?

  /// The maximum value of the circular progress.
  ///
  /// Defaults to `100`.
  public var maxValue: CGFloat = 100

  /// The minimum value of the circular progress.
  ///
  /// Defaults to `0`.
  public var minValue: CGFloat = 0

  /// The shape of the circular progress indicator.
  ///
  /// Defaults to `.circle`.
  public var shape: Shape = .circle

  /// The  size of the circular progress.
  ///
  /// If nil, the view is intended to expand to the available space provided by
  /// the surrounding layout:
  /// - In SwiftUI, constrain it with .frame(...).
  /// - In UIKit, constrain it with Auto Layout.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize? = .medium

  /// Initializes a new instance of `CircularProgressVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension CircularProgressVM {
  var animationDuration: TimeInterval {
    return 0.2
  }
  var circularLineWidth: CGFloat {
    if let lineWidth {
      return lineWidth
    } else if let width = self.preferredSize?.width {
      return max(width / 8, 2)
    } else {
      return 3
    }
  }
  var preferredSize: CGSize? {
    guard let size else {
      return nil
    }

    switch size {
    case .small:
      return CGSize(width: 48, height: 48)
    case .medium:
      return CGSize(width: 64, height: 64)
    case .large:
      return CGSize(width: 80, height: 80)
    }
  }
  func radius(size: CGSize) -> CGFloat {
    return min(size.width, size.height) / 2 - self.circularLineWidth / 2
  }
  func center(size: CGSize) -> CGPoint {
    return .init(x: size.width / 2, y: size.height / 2)
  }
  var startAngle: CGFloat {
    switch self.shape {
    case .circle:
      return -0.5 * .pi
    case .arc:
      return 0.75 * .pi
    }
  }
  var endAngle: CGFloat {
    switch self.shape {
    case .circle:
      return 1.5 * .pi
    case .arc:
      return 2.25 * .pi
    }
  }
  var titleFont: UniversalFont {
    if let font {
      return font
    }
    switch self.size {
    case .small:
      return .smCaption
    case .medium, .none:
      return .mdCaption
    case .large:
      return .lgCaption
    }
  }
}

extension CircularProgressVM {
  var progress: CGFloat {
    let range = self.maxValue - self.minValue
    guard range > 0 else { return 0 }
    let normalized = (self.currentValue - self.minValue) / range
    return max(0, min(1, normalized))
  }

  func progress(for currentValue: CGFloat) -> CGFloat {
    let range = self.maxValue - self.minValue
    guard range > 0 else { return 0 }
    let normalized = (currentValue - self.minValue) / range
    return max(0, min(1, normalized))
  }
}

// MARK: - UIKit Helpers

extension CircularProgressVM {
  func shouldInvalidateIntrinsicContentSize(_ oldModel: Self) -> Bool {
    return self.preferredSize != oldModel.preferredSize
  }
  func shouldUpdateText(_ oldModel: Self) -> Bool {
    return self.label != oldModel.label
  }
  func shouldRecalculateProgress(_ oldModel: Self) -> Bool {
    return self.minValue != oldModel.minValue
    || self.maxValue != oldModel.maxValue
    || self.currentValue != oldModel.currentValue
  }
  func shouldUpdateShape(_ oldModel: Self) -> Bool {
    return self.shape != oldModel.shape
  }
}
