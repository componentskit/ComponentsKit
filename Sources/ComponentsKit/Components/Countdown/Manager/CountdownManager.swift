import SwiftUI

class CountdownManager: ObservableObject, @unchecked Sendable {
  // MARK: - Published Properties

  @Published var days: Int = 0
  @Published var hours: Int = 0
  @Published var minutes: Int = 0
  @Published var seconds: Int = 0

  // MARK: - Properties

  private var timer: Timer?
  private var until: Date?

  deinit {
    self.stop()
  }

  // MARK: - Methods

  func start(until: Date) {
    self.until = until
    self.updateUnitValues()
    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.updateUnitValues()
    }
  }

  func stop() {
    self.timer?.invalidate()
    self.timer = nil
  }

  private func updateUnitValues() {
    guard let until = self.until else { return }

    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents(
      [.day, .hour, .minute, .second],
      from: now,
      to: until
    )
    self.days = max(0, components.day ?? 0)
    self.hours = max(0, components.hour ?? 0)
    self.minutes = max(0, components.minute ?? 0)
    self.seconds = max(0, components.second ?? 0)

    if now >= until {
      self.stop()
    }
  }
}
