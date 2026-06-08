import Foundation

// MARK: - UnitsLocalization

/// A structure that provides localized representations of time units (seconds, minutes, hours, days).
public struct UnitsLocalization: Equatable, Sendable {
  /// A structure that represents the localized short and long forms of a single time unit.
  public struct UnitItemLocalization: Equatable, Sendable {
    /// The short-form representation of the time unit (e.g., "s" for seconds).
    public let short: String
    /// The long-form representation of the time unit (e.g., "Seconds").
    public let long: String

    /// Initializes a new `UnitItemLocalization` with specified short and long forms.
    ///
    /// - Parameters:
    ///   - short: The short-form representation of the time unit.
    ///   - long: The long-form representation of the time unit.
    public init(short: String, long: String) {
      self.short = short
      self.long = long
    }
  }

  // MARK: - Properties

  /// The localized representation for seconds.
  public let seconds: UnitItemLocalization

  /// The localized representation for minutes.
  public let minutes: UnitItemLocalization

  /// The localized representation for hours.
  public let hours: UnitItemLocalization

  /// The localized representation for days.
  public let days: UnitItemLocalization

  // MARK: - Initialization

  /// Initializes a new `UnitsLocalization` with localized representations for all time units.
  ///
  /// - Parameters:
  ///   - seconds: The localization for seconds.
  ///   - minutes: The localization for minutes.
  ///   - hours: The localization for hours.
  ///   - days: The localization for days.
  public init(
    seconds: UnitItemLocalization,
    minutes: UnitItemLocalization,
    hours: UnitItemLocalization,
    days: UnitItemLocalization
  ) {
    self.seconds = seconds
    self.minutes = minutes
    self.hours = hours
    self.days = days
  }
}

// MARK: - Localizations

extension UnitsLocalization {
  static let defaultLocalizations: [Locale: UnitsLocalization] = [
    // English (en)
    Locale(identifier: "en"): UnitsLocalization(
      seconds: .init(short: "s", long: "Seconds"),
      minutes: .init(short: "m", long: "Minutes"),
      hours: .init(short: "h", long: "Hours"),
      days: .init(short: "d", long: "Days")
    ),

    // Spanish (es)
    Locale(identifier: "es"): UnitsLocalization(
      seconds: .init(short: "s", long: "Segundos"),
      minutes: .init(short: "m", long: "Minutos"),
      hours: .init(short: "h", long: "Horas"),
      days: .init(short: "d", long: "Días")
    ),

    // French (fr)
    Locale(identifier: "fr"): UnitsLocalization(
      seconds: .init(short: "s", long: "Secondes"),
      minutes: .init(short: "m", long: "Minutes"),
      hours: .init(short: "h", long: "Heures"),
      days: .init(short: "j", long: "Jours")
    ),

    // German (de)
    Locale(identifier: "de"): UnitsLocalization(
      seconds: .init(short: "s", long: "Sekunden"),
      minutes: .init(short: "m", long: "Minuten"),
      hours: .init(short: "h", long: "Stunden"),
      days: .init(short: "t", long: "Tage")
    ),

    // Chinese (zh)
    Locale(identifier: "zh"): UnitsLocalization(
      seconds: .init(short: "秒", long: "秒"),
      minutes: .init(short: "分", long: "分钟"),
      hours: .init(short: "时", long: "小时"),
      days: .init(short: "天", long: "天")
    ),

    // Japanese (ja)
    Locale(identifier: "ja"): UnitsLocalization(
      seconds: .init(short: "秒", long: "秒"),
      minutes: .init(short: "分", long: "分"),
      hours: .init(short: "時", long: "時間"),
      days: .init(short: "日", long: "日")
    ),

    // Russian (ru)
    Locale(identifier: "ru"): UnitsLocalization(
      seconds: .init(short: "с", long: "Секунд"),
      minutes: .init(short: "м", long: "Минут"),
      hours: .init(short: "ч", long: "Часов"),
      days: .init(short: "д", long: "Дней")
    ),

    // Arabic (ar)
    Locale(identifier: "ar"): UnitsLocalization(
      seconds: .init(short: "ث", long: "ثوانٍ"),
      minutes: .init(short: "د", long: "دقائق"),
      hours: .init(short: "س", long: "ساعات"),
      days: .init(short: "ي", long: "أيام")
    ),

    // Hindi (hi)
    Locale(identifier: "hi"): UnitsLocalization(
      seconds: .init(short: "से", long: "सेकंड"),
      minutes: .init(short: "मि", long: "मिनट"),
      hours: .init(short: "घं", long: "घंटे"),
      days: .init(short: "दि", long: "दिन")
    ),

    // Portuguese (pt)
    Locale(identifier: "pt"): UnitsLocalization(
      seconds: .init(short: "s", long: "Segundos"),
      minutes: .init(short: "m", long: "Minutos"),
      hours: .init(short: "h", long: "Horas"),
      days: .init(short: "d", long: "Dias")
    )
  ]

  static var localizationFallback: UnitsLocalization {
    return UnitsLocalization(
      seconds: .init(short: "s", long: "Seconds"),
      minutes: .init(short: "m", long: "Minutes"),
      hours: .init(short: "h", long: "Hours"),
      days: .init(short: "d", long: "Days")
    )
  }
}
