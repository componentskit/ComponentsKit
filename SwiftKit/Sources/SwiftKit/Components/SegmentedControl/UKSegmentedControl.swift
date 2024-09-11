import UIKit

open class UKSegmentedControl<ID: Hashable>: UIView, UKComponent {
  // MARK: Properties

  public var onSelectionChange: (ID) -> Void

  public var model: SegmentedControlVM<ID> {
    didSet {
      self.update(oldValue)
    }
  }

  public var selectedId: ID {
    didSet {
      guard self.selectedId != oldValue else { return }
      self.onSelectionChange(self.selectedId)
    }
  }

  private var selectedSegmentConstraint = AnchoredConstraints()

  // MARK: Subviews

  public var container = UIView()
  public var segments: [Segment] = []
  public var selectedSegment = UIView()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: Initialization

  public init(
    selectedId: ID,
    model: SegmentedControlVM<ID> = .init(),
    onSelectionChange: @escaping (ID) -> Void = { _ in }
  ) {
    self.selectedId = selectedId
    self.model = model
    self.onSelectionChange = onSelectionChange

    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
    self.update(model)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  func setup() {
    self.addSubview(self.container)
    self.container.addSubview(self.selectedSegment)

    self.setupSegments()
  }

  private func setupSegments() {
    self.model.items.forEach { itemVM in
      let segment = Segment(id: itemVM.id)
      segment.addGestureRecognizer(
        UITapGestureRecognizer(
          target: self,
          action: #selector(self.handleSegmentTap)
        )
      )
      self.segments.append(segment)
      self.container.addSubview(segment)
    }
  }

  // MARK: Style

  func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.selectedSegment(self.selectedSegment, model: self.model)
    self.styleSegments()
  }

  private func styleSegments() {
    self.segments.forEach { segment in
      Self.Style.segment(
        segment,
        model: self.model,
        selectedId: self.selectedId
      )
    }
  }

  // MARK: Layout

  func layout() {
    self.container.pinToEdges(.all, padding: self.model.outerPaddings)

    self.selectedSegment.vertically(0)

    self.layoutSegments()
    self.updateSelectedSegmentLayout()
  }

  private func layoutSegments() {
    let multipliers: [CGFloat]
    if self.model.isFullWidth {
      let multiplier = 1.0 / Double(self.segments.count)
      multipliers = Array(repeating: multiplier, count: self.segments.count)
    } else {
      let segmentWidths = self.segments.map { segment in
        return segment.sizeThatFits(UIView.layoutFittingExpandedSize).width + 2 * (self.model.horizontalInnerPaddings ?? 0)
      }
      let totalWidth = segmentWidths.reduce(into: 0) { result, width in
        result += width
      }
      multipliers = segmentWidths.map { width in
        return width / totalWidth
      }
    }

    self.segments.enumerated().forEach { index, segment in
      segment.widthAnchor.constraint(
        equalTo: self.container.widthAnchor,
        multiplier: multipliers[index]
      ).isActive = true
      segment.vertically(0)

      if let previousSegment = self.segments[safe: index - 1] {
        segment.after(of: previousSegment, padding: 0)
      }
    }

    self.segments.first?.leading()
    self.segments.last?.trailing()
  }

  private func updateSelectedSegmentLayout() {
    self.selectedSegmentConstraint.leading?.isActive = false
    self.selectedSegmentConstraint.trailing?.isActive = false

    guard let selectedSegmentView = self.segment(for: self.selectedId),
          self.model.item(for: self.selectedId)?.isEnabled == true
    else {
      return
    }

    self.selectedSegmentConstraint.leading = self.selectedSegment.leading(to: selectedSegmentView)
    self.selectedSegmentConstraint.trailing = self.selectedSegment.trailing(to: selectedSegmentView)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.selectedSegment.layer.cornerRadius = self.model.preferredCornerRadius.value(
      for: self.selectedSegment.bounds.height
    )
    self.layer.cornerRadius = self.model.preferredCornerRadius.value(
      for: self.bounds.height
    )
  }

  // MARK: Update

  public func update(_ oldModel: SegmentedControlVM<ID>) {
    if self.model.shouldUpdateLayout(oldModel) {
      self.segments.forEach { segment in
        segment.removeFromSuperview()
      }
      self.segments.removeAll()

      self.setupSegments()
      self.styleSegments()
      self.layoutSegments()
      self.updateSelectedSegmentLayout()

      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }

    self.style()
  }

  // MARK: UIView methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    var width: CGFloat

    if self.model.isFullWidth {
      width = self.superview?.bounds.width ?? 10_000
    } else {
      width = self.segments.reduce(into: 0) { result, label in
        result += label.sizeThatFits(UIView.layoutFittingExpandedSize).width + 2 * (self.model.horizontalInnerPaddings ?? 0)
      }
      width += 2 * self.model.outerPaddings
    }

    return .init(
      width: min(width, size.width),
      height: min(self.model.height, size.height)
    )
  }

  // MARK: Helpers

  private func segment(for id: ID) -> Segment? {
    return self.segments.first { segment in
      segment.id == id
    }
  }

  @objc private func handleSegmentTap(sender: UITapGestureRecognizer) {
    guard let segment = sender.view as? Segment,
          self.selectedId != segment.id,
          let currentlySelectedSegment = self.segment(for: self.selectedId)
    else {
      return
    }

    self.selectedId = segment.id

    self.updateSelectedSegmentLayout()
    UIView.animate(
      withDuration: 0.3,
      delay: 0.0,
      options: [.curveEaseInOut],
      animations: {
        self.layoutIfNeeded()

      }
    )
    UIView.transition(
      with: segment,
      duration: 0.3,
      options: .transitionCrossDissolve
    ) {
      Self.Style.segment(
        segment,
        model: self.model,
        selectedId: self.selectedId
      )
    }
    UIView.transition(
      with: currentlySelectedSegment,
      duration: 0.3,
      options: .transitionCrossDissolve
    ) {
      Self.Style.segment(
        currentlySelectedSegment,
        model: self.model,
        selectedId: self.selectedId
      )
    }
  }
}

// MARK: - Style Helpers

extension UKSegmentedControl {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: Model) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.preferredCornerRadius.value(
        for: view.bounds.height
      )
      view.isUserInteractionEnabled = model.isEnabled
    }

    static func selectedSegment(_ view: UIView, model: Model) {
      view.backgroundColor = model.selectedSegmentColor.uiColor
    }

    static func segment(
      _ segment: Segment,
      model: Model,
      selectedId: ID
    ) {
      guard let itemVM = model.item(for: segment.id) else {
        return
      }
      segment.text = itemVM.title
      segment.font = model.preferredFont(for: segment.id).uiFont
      segment.textColor = model.foregroundColor(
        id: segment.id,
        selectedId: selectedId
      ).uiColor
      segment.textAlignment = .center
      segment.isUserInteractionEnabled = itemVM.isEnabled
    }
  }
}

// MARK: - Segment

extension UKSegmentedControl {
  public class Segment: UILabel {
    public fileprivate(set) var id: ID

    init(id: ID) {
      self.id = id

      super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
