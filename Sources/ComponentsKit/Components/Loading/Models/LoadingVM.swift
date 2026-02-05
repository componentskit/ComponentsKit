import Foundation

/// A model that defines the appearance properties for a loading indicator component.
public struct LoadingVM: ComponentVM {
  /// The color of the loading indicator.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The width of the lines used in the loading indicator.
  ///
  /// If not provided, the line width is automatically adjusted based on the size.
  public var lineWidth: CGFloat?

  /// The predefined size of the loading indicator.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `LoadingVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension LoadingVM {
  var loadingLineWidth: CGFloat {
    return self.lineWidth ?? max(self.preferredSize.width / 8, 2)
  }
  var preferredSize: CGSize {
    switch self.size {
    case .small:
      return .init(width: 24, height: 24)
    case .medium:
      return .init(width: 36, height: 36)
    case .large:
      return .init(width: 48, height: 48)
    }
  }
  var radius: CGFloat {
    return self.preferredSize.height / 2 - self.loadingLineWidth / 2
  }
}

// MARK: UIKit Helpers

extension LoadingVM {
  func shouldUpdateShapePath(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size || self.lineWidth != oldModel.lineWidth
  }
}

// MARK: SwiftUI Helpers

extension LoadingVM {
  var center: CGPoint {
    return .init(
      x: self.preferredSize.width / 2,
      y: self.preferredSize.height / 2
    )
  }
}
