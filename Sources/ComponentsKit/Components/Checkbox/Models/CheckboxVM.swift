import SwiftUI

/// A model that defines the appearance properties for a checkbox component.
public struct CheckboxVM: ComponentVM {
  /// The label text displayed next to the checkbox.
  public var title: String?

  /// The color of the checkbox.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The corner radius of the checkbox.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the checkbox label text.
  /// 
  /// If not provided, the font is automatically calculated based on the checkbox's size.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the checkbox is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// The predefined size of the checkbox.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `CheckboxVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension CheckboxVM {
  var backgroundColor: UniversalColor {
    return self.color.main.enabled(self.isEnabled)
  }
  var foregroundColor: UniversalColor {
    return self.color.contrast.enabled(self.isEnabled)
  }
  var titleColor: UniversalColor {
    return .foreground.enabled(self.isEnabled)
  }
  var borderColor: UniversalColor {
    return .divider
  }
  var borderWidth: CGFloat {
    return 2.0
  }
  var spacing: CGFloat {
    return self.title.isNil ? 0.0 : 8.0
  }
  var checkmarkLineWidth: CGFloat {
    switch self.size {
    case .small:
      return 1.5
    case .medium:
      return 1.75
    case .large:
      return 2.0
    }
  }
  var checkboxSide: CGFloat {
    switch self.size {
    case .small:
      return 20.0
    case .medium:
      return 24.0
    case .large:
      return 28.0
    }
  }
  var checkboxCornerRadius: CGFloat {
    switch self.cornerRadius {
    case .none:
      return 0.0
    case .small:
      return self.checkboxSide / 3.5
    case .medium:
      return self.checkboxSide / 3.0
    case .large:
      return self.checkboxSide / 2.5
    case .full:
      return self.checkboxSide / 2.0
    case .custom(let value):
      return min(value, self.checkboxSide / 2)
    }
  }
  var titleFont: UniversalFont {
    if let font {
      return font
    }

    switch self.size {
    case .small:
      return .smBody
    case .medium:
      return .mdBody
    case .large:
      return .lgBody
    }
  }
  var checkmarkPath: CGPath {
    let path = UIBezierPath()
    path.move(to: .init(
      x: 7 / 24 * self.checkboxSide,
      y: 12 / 24 * self.checkboxSide
    ))
    path.addLine(to: .init(
      x: 11 / 24 * self.checkboxSide,
      y: 16 / 24 * self.checkboxSide
    ))
    path.addLine(to: .init(
      x: 17 / 24 * self.checkboxSide,
      y: 8 / 24 * self.checkboxSide
    ))
    return path.cgPath
  }
}

// MARK: UIKit Helpers

extension CheckboxVM {
  func shouldAddLabel(_ oldModel: Self) -> Bool {
    return self.title.isNotNilAndEmpty && oldModel.title.isNilOrEmpty
  }
  func shouldRemoveLabel(_ oldModel: Self) -> Bool {
    return self.title.isNilOrEmpty && oldModel.title.isNotNilAndEmpty
  }
  func shouldUpdateSize(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
  }
  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
    || self.title.isNotNilAndEmpty && oldModel.title.isNilOrEmpty
    || self.title.isNilOrEmpty && oldModel.title.isNotNilAndEmpty
  }
}
