import AutoLayout
import UIKit

/// A UIKit component that displays a group of radio buttons, allowing users to select one option from multiple choices.
open class UKRadioGroup<ID: Hashable & Sendable>: UIView, UKComponent, UIGestureRecognizerDelegate {
  // MARK: Properties

  /// A closure that is triggered when a selected segment changes.
  public var onSelectionChange: ((ID?) -> Void)?

  /// A model that defines the appearance properties.
  public var model: RadioGroupVM<ID> {
    didSet {
      self.update(oldValue)
    }
  }

  /// An identifier of the selected item.
  public var selectedId: ID? {
    didSet {
      guard self.selectedId != oldValue else { return }
      self.updateSelection(oldValue)
      self.onSelectionChange?(self.selectedId)
    }
  }
  /// The identifier of the radio button currently being tapped.
  private var tappingId: ID?

  // MARK: Subviews

  /// A stack view that contains radio button items.
  public var stackView = UIStackView()
  private var items: [ID: RadioGroupItemView<ID>] = [:]

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialSelectedId: The initial identifier of the selected radio button.
  ///   - model: A model that defines the appearance properties.
  ///   - onSelectionChange: A closure that is triggered when the selected radio button changes.
  public init(
    initialSelectedId: ID? = nil,
    model: RadioGroupVM<ID>,
    onSelectionChange: ((ID?) -> Void)? = nil
  ) {
    self.selectedId = initialSelectedId
    self.model = model
    self.onSelectionChange = onSelectionChange
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.stackView)
    self.setupItems()
  }

  private func setupItems() {
    self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    self.items.removeAll()

    self.model.items.forEach { item in
      let radioGroupItemView = RadioGroupItemView(
        isSelected: self.selectedId == item.id,
        groupVM: self.model,
        itemVM: item
      )

      let longPressGesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(self.handleContainerLongPress(_:))
      )
      longPressGesture.minimumPressDuration = 0
      longPressGesture.delegate = self
      radioGroupItemView.addGestureRecognizer(longPressGesture)

      self.items[item.id] = radioGroupItemView

      self.stackView.addArrangedSubview(radioGroupItemView)
    }
  }

  // MARK: Style

  private func style() {
    Self.Style.stackView(self.stackView, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.stackView.allEdges()
  }

  // MARK: Update

  public func update(_ oldModel: RadioGroupVM<ID>) {
    guard self.model != oldModel else { return }

    self.stackView.spacing = self.model.spacing

    if self.model.shouldUpdateLayout(oldModel) {
      self.setupItems()
    } else {
      self.model.items.forEach { item in
        self.items[item.id]?.groupVM = self.model
      }
    }
  }

  private func updateSelection(_ oldSelection: ID?) {
    if let oldSelection {
      self.items[oldSelection]?.isSelected = false
    }
    if let selectedId {
      self.items[selectedId]?.isSelected = true
    }
  }

  // MARK: Helpers

  private func animateRadioView(for id: ID, scale: CGFloat) {
    guard let radioView = self.items[id]?.radioView else { return }
    UIView.animate(
      withDuration: 0.1,
      delay: 0,
      options: [.curveEaseOut],
      animations: {
        radioView.transform = CGAffineTransform(scaleX: scale, y: scale)
      },
      completion: nil
    )
  }

  // MARK: Gesture Handlers

  @objc private func handleContainerLongPress(_ sender: UILongPressGestureRecognizer) {
    guard let tappedView = sender.view as? RadioGroupItemView<ID> else { return }
    let tappedId = tappedView.itemVM.id

    switch sender.state {
    case .began:
      self.tappingId = tappedId
      self.animateRadioView(for: tappedId, scale: self.model.animationScale.value)
    case .ended:
      self.tappingId = nil
      self.animateRadioView(for: tappedId, scale: 1.0)

      if tappedView.bounds.contains(sender.location(in: tappedView)) {
        self.selectedId = tappedId
      }
    case .cancelled, .failed:
      self.tappingId = nil
      self.animateRadioView(for: tappedId, scale: 1.0)
    default:
      break
    }
  }

  // MARK: UKRadioGroup + UIGestureRecognizerDelegate

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return true
  }
}

// MARK: - Style Helpers

extension UKRadioGroup {
  @MainActor
  fileprivate enum Style {
    static func stackView(_ stackView: UIStackView, model: Model) {
      stackView.axis = .vertical
      stackView.alignment = .leading
      stackView.spacing = model.spacing
      stackView.distribution = .equalSpacing
    }
  }
}
