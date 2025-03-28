import SwiftUI
import UIKit

/// A model that defines the appearance properties for a text input component.
public struct TextInputVM: ComponentVM {
  /// The autocapitalization behavior for the text input.
  ///
  /// Defaults to `.sentences`, which capitalizes the first letter of each sentence.
  public var autocapitalization: TextAutocapitalization = .sentences

  /// The color of the text input.
  public var color: ComponentColor?

  /// The corner radius of the text input.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the text input's text.
  ///
  /// If not provided, the font is determined based on the text input's `size`.
  public var font: UniversalFont?

  /// A Boolean value indicating whether autocorrection is enabled.
  ///
  /// Defaults to `true`.
  public var isAutocorrectionEnabled: Bool = true

  /// A Boolean value indicating whether the text input is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// The type of keyboard to display when the text input is active.
  ///
  /// Defaults to `.default`.
  public var keyboardType: UIKeyboardType = .default

  /// The maximum number of rows the text input can expand to.
  ///
  /// If `nil`, the text input has no row limit.
  public var maxRows: Int?

  /// The minimum number of rows the text input can occupy.
  public var minRows: Int = 2

  /// The placeholder text displayed when there is no input.
  public var placeholder: String?

  /// The predefined size of the text input.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The type of the submit button on the keyboard.
  ///
  /// Defaults to `.return`.
  public var submitType: SubmitType = .return

  /// The tint color applied to the text input's cursor.
  ///
  /// Defaults to `.accent`.
  public var tintColor: UniversalColor = .accent

  /// Initializes a new instance of `TextInputVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension TextInputVM {
  var preferredFont: UniversalFont {
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

  var contentPadding: CGFloat {
    return 12
  }

  var backgroundColor: UniversalColor {
    return self.color?.background ?? .content1
  }

  var foregroundColor: UniversalColor {
    let color = self.color?.main ?? .foreground
    return color.enabled(self.isEnabled)
  }

  var placeholderColor: UniversalColor {
    if let color {
      return color.main.withOpacity(self.isEnabled ? 0.7 : 0.3)
    } else {
      return .secondaryForeground.enabled(self.isEnabled)
    }
  }

  var minTextInputHeight: CGFloat {
    let numberOfRows: Int
    if let maxRows {
      numberOfRows = min(maxRows, self.minRows)
    } else {
      numberOfRows = self.minRows
    }
    return self.height(forRows: numberOfRows)
  }

  var maxTextInputHeight: CGFloat {
    if let maxRows {
      return self.height(forRows: maxRows)
    } else {
      return 10_000
    }
  }

  func adaptedCornerRadius(for height: CGFloat = 10_000) -> CGFloat {
    switch self.cornerRadius {
    case .none, .small, .medium, .large, .full:
      let value = self.cornerRadius.value(for: height)
      let maxValue = ComponentRadius.custom(self.height(forRows: 1) / 2).value(for: height)
      return min(value, maxValue)
    case .custom(let value):
      return ComponentRadius.custom(value).value(for: height)
    }
  }

  private func height(forRows rows: Int) -> CGFloat {
    if rows < 1 {
      assertionFailure("Number of rows in TextInput must be greater than or equal to 1")
    }
    let numberOfRows = max(1, rows)
    return self.preferredFont.uiFont.lineHeight * CGFloat(numberOfRows) + 2 * self.contentPadding
  }

  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
    || self.font != oldModel.font
    || self.minRows != oldModel.minRows
    || self.maxRows != oldModel.maxRows
  }
}

// MARK: - UIKit Helpers

extension TextInputVM {
  var autocorrectionType: UITextAutocorrectionType {
    return self.isAutocorrectionEnabled ? .yes : .no
  }
}
