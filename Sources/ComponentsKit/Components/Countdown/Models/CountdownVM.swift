import SwiftUI

/// A model that defines the appearance properties for a countdown component.
public struct CountdownVM: ComponentVM {
  /// The color of the countdown.
  public var color: ComponentColor?

  /// The locale used for localizing the countdown.
  public var locale: Locale = .current

  /// A dictionary containing localized representations of time units (days, hours, minutes, seconds) for various locales.
  ///
  /// This property can be used to override the default localizations for supported languages or to add
  /// localizations for unsupported languages. By default, the library provides strings for the following locales:
  /// - English ("en")
  /// - Spanish ("es")
  /// - French ("fr")
  /// - German ("de")
  /// - Chinese ("zh")
  /// - Japanese ("ja")
  /// - Russian ("ru")
  /// - Arabic ("ar")
  /// - Hindi ("hi")
  /// - Portuguese ("pt")
  public var localization: [Locale: UnitsLocalization] = [:]

  /// The font used for displaying the countdown numbers and trailing units.
  public var mainFont: UniversalFont?

  /// The font used for displaying the countdown bottom units.
  public var secondaryFont: UniversalFont?

  /// The predefined size of the countdown.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The visual style of the countdown component.
  ///
  /// Defaults to `.light`.
  public var style: Style = .light

  /// The visual style of the units.
  ///
  /// Defaults to `.bottom`.
  public var unitsStyle: UnitsStyle = .bottom

  /// The target date until which the countdown runs.
  public var until: Date = Date().addingTimeInterval(3600 * 85)

  /// Initializes a new instance of `CountdownVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension CountdownVM {
  var preferredMainFont: UniversalFont {
    if let mainFont {
      return mainFont
    }

    switch self.size {
    case .small:
      return .smHeadline
    case .medium:
      return .mdHeadline
    case .large:
      return .lgHeadline
    }
  }
  private var preferredSecondaryFont: UniversalFont {
    if let secondaryFont {
      return secondaryFont
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
  var backgroundColor: UniversalColor {
    return self.color?.background ?? .content1
  }
  var foregroundColor: UniversalColor {
    return self.color?.main ?? .foreground
  }
  var colonColor: UniversalColor {
    return self.color?.main ?? .secondaryForeground
  }
  var defaultMinWidth: CGFloat {
    return switch self.size {
    case .small: 20
    case .medium: 25
    case .large: 30
    }
  }
  var lightBackgroundMinHight: CGFloat {
    return switch self.size {
    case .small: 45
    case .medium: 55
    case .large: 65
    }
  }
  var lightBackgroundMinWidth: CGFloat {
    return switch self.size {
    case .small: 45
    case .medium: 55
    case .large: 60
    }
  }
  var horizontalPadding: CGFloat {
    switch self.style {
    case .light:
      return 4
    case .plain:
      return 0
    }
  }
  var spacing: CGFloat {
    switch self.style {
    case .light:
      return 10
    case .plain:
      return 6
    }
  }
}

extension CountdownVM {
  func localizedUnit(
    _ unit: CountdownHelpers.Unit,
    length: CountdownHelpers.UnitLength
  ) -> String {
    let localization = self.localization[self.locale]
    ?? UnitsLocalization.defaultLocalizations[self.locale]
    ?? UnitsLocalization.localizationFallback

    switch (unit, length) {
    case (.days, .long):
      return localization.days.long
    case (.days, .short):
      return localization.days.short

    case (.hours, .long):
      return localization.hours.long
    case (.hours, .short):
      return localization.hours.short

    case (.minutes, .long):
      return localization.minutes.long
    case (.minutes, .short):
      return localization.minutes.short

    case (.seconds, .long):
      return localization.seconds.long
    case (.seconds, .short):
      return localization.seconds.short
    }
  }

  func timeText(
    value: Int,
    unit: CountdownHelpers.Unit
  ) -> NSAttributedString {
    let mainTextAttributes: [NSAttributedString.Key: Any] = [
      .font: self.preferredMainFont.uiFont,
      .foregroundColor: self.foregroundColor.uiColor
    ]

    let formattedValue = String(format: "%02d", value)
    let result = NSMutableAttributedString(string: formattedValue, attributes: mainTextAttributes)

    switch self.unitsStyle {
    case .hidden:
      return result

    case .trailing:
      let localized = self.localizedUnit(unit, length: .short)
      let trailingString = " " + localized
      let trailingAttributes: [NSAttributedString.Key: Any] = [
        .font: self.preferredMainFont.uiFont,
        .foregroundColor: self.foregroundColor.uiColor
      ]
      result.append(NSAttributedString(string: trailingString, attributes: trailingAttributes))
      return result

    case .bottom:
      let localized = self.localizedUnit(unit, length: .long)
      let bottomString = "\n" + localized
      let bottomAttributes: [NSAttributedString.Key: Any] = [
        .font: self.preferredSecondaryFont.uiFont,
        .foregroundColor: self.foregroundColor.uiColor
      ]
      result.append(NSAttributedString(string: bottomString, attributes: bottomAttributes))
      return result
    }
  }
}

extension CountdownVM {
  func shouldRecalculateWidth(_ oldModel: Self) -> Bool {
    return self.unitsStyle != oldModel.unitsStyle
    || self.style != oldModel.style
    || self.mainFont != oldModel.mainFont
    || self.secondaryFont != oldModel.secondaryFont
    || self.size != oldModel.size
    || self.locale != oldModel.locale
  }

  @MainActor
  func timeWidth(manager: CountdownManager) -> CGFloat {
    let values: [(Int, CountdownHelpers.Unit)] = [
      (manager.days, .days),
      (manager.hours, .hours),
      (manager.minutes, .minutes),
      (manager.seconds, .seconds)
    ]

    let widths = values.map { value, unit -> CGFloat in
      let attributedString = self.timeText(value: value, unit: unit)
      return CountdownWidthCalculator.preferredWidth(for: attributedString, model: self)
    }

    return (widths.max() ?? self.defaultMinWidth) + self.horizontalPadding * 2
  }
}

// MARK: - UIKit Helpers

extension CountdownVM {
  var isColumnLabelVisible: Bool {
    switch self.style {
    case .plain:
      return true
    case .light:
      return false
    }
  }

  func shouldUpdateHeight(_ oldModel: Self) -> Bool {
    return self.style != oldModel.style
    || self.size != oldModel.size
  }
}
