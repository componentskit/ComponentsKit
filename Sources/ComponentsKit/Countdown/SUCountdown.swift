import SwiftUI

/// A SwiftUI component that displays a countdown.
public struct SUCountdown: View {
  // MARK: - Properties

  /// The countdown manager handling the countdown logic.
  @StateObject private var manager = CountdownManager()

  /// A model that defines the appearance properties.
  public var model: CountdownVM

  @Environment(\.colorScheme) private var colorScheme

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: CountdownVM = .init()) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    VStack {
      switch self.model.style {
      case .plain:
        switch self.model.unitsPosition {
        case .hidden:
          self.plainNoneLayout
        case .bottom:
          self.plainBottomLayout
        case .trailing:
          self.plainTrailingLayout
        }

      case .light:
        switch self.model.unitsPosition {
        case .hidden:
          self.lightNoneLayout
        case .bottom:
          self.lightBottomLayout
        case .trailing:
          self.lightTrailingLayout
        }
      }
    }
    .onAppear {
      self.manager.start(until: self.model.until)
    }
    .onChange(of: model.until) { newDate in
      self.manager.stop()
      self.manager.start(until: newDate)
    }
    .onDisappear {
      self.manager.stop()
    }
  }

  // MARK: - Layouts for Style .plain

  private var plainNoneLayout: some View {
    HStack(spacing: 6) {
      self.plainStyledText(value: self.manager.days)
      self.colonView
      self.plainStyledText(value: self.manager.hours)
      self.colonView
      self.plainStyledText(value: self.manager.minutes)
      self.colonView
      self.plainStyledText(value: self.manager.seconds)
    }
  }

  private var plainBottomLayout: some View {
    HStack(spacing: 10) {
      self.plainUnitView(value: self.manager.days, unit: .days)
      self.colonView.padding(.bottom, 16)
      self.plainUnitView(value: self.manager.hours, unit: .hours)
      self.colonView.padding(.bottom, 16)
      self.plainUnitView(value: self.manager.minutes, unit: .minutes)
      self.colonView.padding(.bottom, 16)
      self.plainUnitView(value: self.manager.seconds, unit: .seconds)
    }
  }

  private var plainTrailingLayout: some View {
    HStack(spacing: 6) {
      self.plainStyledTimeWithShortUnit(value: self.manager.days, unit: .days)
      self.colonView
      self.plainStyledTimeWithShortUnit(value: self.manager.hours, unit: .hours)
      self.colonView
      self.plainStyledTimeWithShortUnit(value: self.manager.minutes, unit: .minutes)
      self.colonView
      self.plainStyledTimeWithShortUnit(value: self.manager.seconds, unit: .seconds)
    }
  }

  // MARK: - Layouts for Style .light

  private var lightNoneLayout: some View {
    HStack(spacing: 10) {
      self.lightBackground {
        self.plainStyledText(value: self.manager.days)
      }
      self.lightBackground {
        self.plainStyledText(value: self.manager.hours)
      }
      self.lightBackground {
        self.plainStyledText(value: self.manager.minutes)
      }
      self.lightBackground {
        self.plainStyledText(value: self.manager.seconds)
      }
    }
  }

  private var lightBottomLayout: some View {
    HStack(spacing: 10) {
      self.lightUnitView(value: self.manager.days, unit: .days)
      self.lightUnitView(value: self.manager.hours, unit: .hours)
      self.lightUnitView(value: self.manager.minutes, unit: .minutes)
      self.lightUnitView(value: self.manager.seconds, unit: .seconds)
    }
  }

  private var lightTrailingLayout: some View {
    HStack(spacing: 10) {
      self.lightBackground {
        self.plainStyledTimeWithShortUnit(value: self.manager.days, unit: .days)
      }
      self.lightBackground {
        self.plainStyledTimeWithShortUnit(value: self.manager.hours, unit: .hours)
      }
      self.lightBackground {
        self.plainStyledTimeWithShortUnit(value: self.manager.minutes, unit: .minutes)
      }
      self.lightBackground {
        self.plainStyledTimeWithShortUnit(value: self.manager.seconds, unit: .seconds)
      }
    }
  }

  // MARK: - Methods

  private var colonView: some View {
    Text(":")
      .font(self.model.preferredFont.font)
      .foregroundColor(.gray)
  }

  private func plainStyledText(value: Int) -> some View {
    Text(String(format: "%02d", value))
      .font(self.model.preferredFont.font)
      .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
  }

  private func plainStyledTimeWithShortUnit(value: Int, unit: CountdownHelpers.Unit) -> some View {
    Text(String(format: "%02d %@", value, self.localizedUnit(unit, length: .short)))
      .font(self.model.preferredFont.font)
      .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
  }

  private func lightBackground<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
    content()
      .frame(width: 55, height: self.model.height)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(self.model.backgroundColor.color(for: self.colorScheme))
      )
  }

  private func plainUnitView(value: Int, unit: CountdownHelpers.Unit) -> some View {
    VStack(spacing: 2) {
      self.plainStyledText(value: value)
      self.unitLabel(for: unit)
    }
  }

  private func lightUnitView(value: Int, unit: CountdownHelpers.Unit) -> some View {
    lightBackground {
      VStack(spacing: 2) {
        self.plainStyledText(value: value)
        self.unitLabel(for: unit)
      }
    }
  }

  private func unitLabel(for unit: CountdownHelpers.Unit) -> some View {
    Text(self.localizedUnit(unit, length: .long))
      .font(self.model.unitFont.font)
      .foregroundStyle(
        self.model.foregroundColor.color(for: self.colorScheme)
      )
  }

  private func localizedUnit(_ unit: CountdownHelpers.Unit, length: CountdownHelpers.UnitLength) -> String {
    let localization = model.localization[model.locale]
    ?? UnitsLocalization.defaultLocalizations[model.locale]
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
}
