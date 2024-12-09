import Foundation

public struct UnitsLocalization: Equatable {
  public struct UnitItemLocalization: Equatable {
    public let short: String
    public let long: String

    public init(short: String, long: String) {
      self.short = short
      self.long = long
    }
  }

  public let seconds: UnitItemLocalization
  public let minutes: UnitItemLocalization
  public let hours: UnitItemLocalization
  public let days: UnitItemLocalization

  public init(seconds: UnitItemLocalization, minutes: UnitItemLocalization, hours: UnitItemLocalization, days: UnitItemLocalization) {
    self.seconds = seconds
    self.minutes = minutes
    self.hours = hours
    self.days = days
  }
}

public let defaultLocalizations: [Locale: UnitsLocalization] = [
  Locale(identifier: "en"): UnitsLocalization(
    seconds: .init(short: "s", long: "Seconds"),
    minutes: .init(short: "m", long: "Minutes"),
    hours: .init(short: "h", long: "Hours"),
    days: .init(short: "d", long: "Days")
  ),
  Locale(identifier: "es"): UnitsLocalization(
    seconds: .init(short: "s", long: "Segundos"),
    minutes: .init(short: "m", long: "Minutos"),
    hours: .init(short: "h", long: "Horas"),
    days: .init(short: "d", long: "Días")
  ),
  Locale(identifier: "fr"): UnitsLocalization(
    seconds: .init(short: "s", long: "Secondes"),
    minutes: .init(short: "m", long: "Minutes"),
    hours: .init(short: "h", long: "Heures"),
    days: .init(short: "j", long: "Jours")
  ),
  Locale(identifier: "de"): UnitsLocalization(
    seconds: .init(short: "s", long: "Sekunden"),
    minutes: .init(short: "m", long: "Minuten"),
    hours: .init(short: "h", long: "Stunden"),
    days: .init(short: "t", long: "Tage")
  ),
  Locale(identifier: "zh"): UnitsLocalization(
    seconds: .init(short: "秒", long: "秒"),
    minutes: .init(short: "分", long: "分钟"),
    hours: .init(short: "时", long: "小时"),
    days: .init(short: "天", long: "天")
  ),
  Locale(identifier: "ja"): UnitsLocalization(
    seconds: .init(short: "秒", long: "秒"),
    minutes: .init(short: "分", long: "分"),
    hours: .init(short: "時", long: "時間"),
    days: .init(short: "日", long: "日")
  ),
  Locale(identifier: "ru"): UnitsLocalization(
    seconds: .init(short: "с", long: "Секунд"),
    minutes: .init(short: "м", long: "Минут"),
    hours: .init(short: "ч", long: "Часов"),
    days: .init(short: "д", long: "Дней")
  ),
  Locale(identifier: "ar"): UnitsLocalization(
    seconds: .init(short: "ث", long: "ثوانٍ"),
    minutes: .init(short: "د", long: "دقائق"),
    hours: .init(short: "س", long: "ساعات"),
    days: .init(short: "ي", long: "أيام")
  ),
  Locale(identifier: "hi"): UnitsLocalization(
    seconds: .init(short: "से", long: "सेकंड"),
    minutes: .init(short: "मि", long: "मिनट"),
    hours: .init(short: "घं", long: "घंटे"),
    days: .init(short: "दि", long: "दिन")
  ),
  Locale(identifier: "pt"): UnitsLocalization(
    seconds: .init(short: "s", long: "Segundos"),
    minutes: .init(short: "m", long: "Minutos"),
    hours: .init(short: "h", long: "Horas"),
    days: .init(short: "d", long: "Dias")
  )
]
