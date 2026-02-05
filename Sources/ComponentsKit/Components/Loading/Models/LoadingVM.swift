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
  /// If nil, the loader is intended to expand to the available space provided by
  /// the surrounding layout:
  /// - In SwiftUI, constrain it with .frame(...).
  /// - In UIKit, constrain it with Auto Layout.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize? = .medium

  /// Initializes a new instance of `LoadingVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension LoadingVM {
  var loadingLineWidth: CGFloat {
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
      return .init(width: 24, height: 24)
    case .medium:
      return .init(width: 36, height: 36)
    case .large:
      return .init(width: 48, height: 48)
    }
  }
}

// MARK: UIKit Helpers

extension LoadingVM {
  func shouldUpdateShapePath(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size || self.lineWidth != oldModel.lineWidth
  }
}
