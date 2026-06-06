import AutoLayout
import Combine
import UIKit

/// A UIKit timer component that counts down from a specified duration to zero.
open class UKCountdown: UIView, UKComponent {
  // MARK: - Public Properties

  /// A model that defines the appearance properties.
  public var model: CountdownVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: - Subviews

  /// The main container stack view containing all time labels and colon labels.
  public let stackView = UIStackView()

  /// A label showing the number of days remaining.
  public let daysLabel = UILabel()

  /// A label showing the number of hours remaining.
  public let hoursLabel = UILabel()

  /// A label showing the number of minutes remaining.
  public let minutesLabel = UILabel()

  /// A label showing the number of seconds remaining.
  public let secondsLabel = UILabel()

  /// An array of colon labels used as separators between the time segments (days/hours/minutes/seconds).
  public let colonLabels: [UILabel] = [
    UILabel(),
    UILabel(),
    UILabel()
  ]

  // MARK: - Private Properties

  /// Constraints specifically applied to the "days" label.
  private var daysConstraints = LayoutConstraints()

  private let manager = CountdownManager()

  private var cancellables: Set<AnyCancellable> = []

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: CountdownVM) {
    self.model = model

    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.manager.stop()
    self.cancellables.forEach {
      $0.cancel()
    }
  }

  // MARK: - Setup

  private func setup() {
    self.addSubview(self.stackView)

    self.stackView.addArrangedSubview(self.daysLabel)
    self.stackView.addArrangedSubview(self.colonLabels[0])
    self.stackView.addArrangedSubview(self.hoursLabel)
    self.stackView.addArrangedSubview(self.colonLabels[1])
    self.stackView.addArrangedSubview(self.minutesLabel)
    self.stackView.addArrangedSubview(self.colonLabels[2])
    self.stackView.addArrangedSubview(self.secondsLabel)

    self.setupSubscriptions()
    self.manager.start(until: self.model.until)
  }

  private func setupSubscriptions() {
    self.manager.$days
      .sink { [weak self] newValue in
        guard let self else { return }
        self.daysLabel.attributedText = self.model.timeText(value: newValue, unit: .days)
      }
      .store(in: &self.cancellables)

    self.manager.$hours
      .sink { [weak self] newValue in
        guard let self else { return }
        self.hoursLabel.attributedText = self.model.timeText(value: newValue, unit: .hours)
      }
      .store(in: &self.cancellables)

    self.manager.$minutes
      .sink { [weak self] newValue in
        guard let self else { return }
        self.minutesLabel.attributedText = self.model.timeText(value: newValue, unit: .minutes)
      }
      .store(in: &self.cancellables)

    self.manager.$seconds
      .sink { [weak self] newValue in
        guard let self else { return }
        self.secondsLabel.attributedText = self.model.timeText(value: newValue, unit: .seconds)
      }
      .store(in: &self.cancellables)
  }

  // MARK: - Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.stackView(self.stackView, model: self.model)

    Self.Style.timeLabel(self.daysLabel, model: self.model)
    Self.Style.timeLabel(self.hoursLabel, model: self.model)
    Self.Style.timeLabel(self.minutesLabel, model: self.model)
    Self.Style.timeLabel(self.secondsLabel, model: self.model)

    self.colonLabels.forEach {
      Self.Style.colonLabel($0, model: self.model)
    }

    self.daysLabel.attributedText = self.model.timeText(value: self.manager.days, unit: .days)
    self.hoursLabel.attributedText = self.model.timeText(value: self.manager.hours, unit: .hours)
    self.minutesLabel.attributedText = self.model.timeText(value: self.manager.minutes, unit: .minutes)
    self.secondsLabel.attributedText = self.model.timeText(value: self.manager.seconds, unit: .seconds)
  }

  // MARK: - Layout

  private func layout() {
    self.stackView.centerVertically()
    self.stackView.centerHorizontally()

    self.stackView.topAnchor.constraint(
      greaterThanOrEqualTo: self.topAnchor
    ).isActive = true
    self.stackView.bottomAnchor.constraint(
      lessThanOrEqualTo: self.bottomAnchor
    ).isActive = true
    self.stackView.leadingAnchor.constraint(
      greaterThanOrEqualTo: self.leadingAnchor
    ).isActive = true
    self.stackView.trailingAnchor.constraint(
      lessThanOrEqualTo: self.trailingAnchor
    ).isActive = true

    self.daysConstraints.width = self.daysLabel.widthAnchor.constraint(
      equalToConstant: self.model.defaultMinWidth
    )
    self.daysConstraints.width?.isActive = true

    self.daysConstraints.height = self.daysLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: self.model.lightBackgroundMinHight)
    self.daysConstraints.height?.isActive = true

    self.hoursLabel.widthAnchor.constraint(equalTo: self.daysLabel.widthAnchor).isActive = true
    self.hoursLabel.heightAnchor.constraint(equalTo: self.daysLabel.heightAnchor).isActive = true

    self.minutesLabel.widthAnchor.constraint(equalTo: self.daysLabel.widthAnchor).isActive = true
    self.minutesLabel.heightAnchor.constraint(equalTo: self.daysLabel.heightAnchor).isActive = true

    self.secondsLabel.widthAnchor.constraint(equalTo: self.daysLabel.widthAnchor).isActive = true
    self.secondsLabel.heightAnchor.constraint(equalTo: self.daysLabel.heightAnchor).isActive = true

    switch self.model.style {
    case .plain:
      self.daysConstraints.height?.isActive = false
      self.daysConstraints.width?.constant = self.model.timeWidth(manager: self.manager)
    case .light:
      self.daysConstraints.width?.constant = max(
        self.model.timeWidth(manager: self.manager),
        self.model.lightBackgroundMinWidth
      )
    }
  }

  // MARK: - Update

  public func update(_ oldModel: CountdownVM) {
    guard self.model != oldModel else { return }

    if self.model.until != oldModel.until {
      self.manager.stop()
      self.manager.start(until: self.model.until)
    }

    if self.model.shouldUpdateHeight(oldModel) {
      switch self.model.style {
      case .plain:
        self.daysConstraints.height?.isActive = false
      case .light:
        self.daysConstraints.height?.isActive = true
        self.daysConstraints.height?.constant = self.model.lightBackgroundMinHight
      }
    }

    if self.model.shouldRecalculateWidth(oldModel) {
      let newWidth = self.model.timeWidth(manager: self.manager)
      switch self.model.style {
      case .plain:
        self.daysConstraints.width?.constant = newWidth
      case .light:
        self.daysConstraints.width?.constant = max(newWidth, self.model.lightBackgroundMinWidth)
      }
    }

    self.style()

    self.layoutIfNeeded()
  }
}

// MARK: - Style Helpers

extension UKCountdown {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: CountdownVM) {
      view.backgroundColor = .clear
    }

    static func stackView(_ stackView: UIStackView, model: CountdownVM) {
      stackView.axis = .horizontal
      stackView.alignment = .top
      stackView.spacing = model.spacing
    }

    static func timeLabel(_ label: UILabel, model: CountdownVM) {
      switch model.style {
      case .plain:
        label.backgroundColor = .clear
        label.layer.cornerRadius = 0
      case .light:
        label.backgroundColor = model.backgroundColor.uiColor
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
      }
      label.textColor = model.foregroundColor.uiColor
      label.textAlignment = .center
      label.numberOfLines = 0
      label.lineBreakMode = .byClipping
    }

    static func colonLabel(_ label: UILabel, model: CountdownVM) {
      label.text = ":"
      label.font = model.preferredMainFont.uiFont
      label.textColor = model.colonColor.uiColor
      label.textAlignment = .center
      label.isVisible = model.isColumnLabelVisible
    }
  }
}
