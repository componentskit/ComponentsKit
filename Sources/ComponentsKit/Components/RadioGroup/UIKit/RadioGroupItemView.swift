import AutoLayout
import UIKit

/// A view representing a single radio button item in a radio group.
open class RadioGroupItemView<ID: Hashable>: UIView {
  // MARK: Properties

  /// A view that represents an outer circle and contains an inner circle.
  public let radioView = UIView()
  /// A view that represents an inner circle in the radio button.
  public let innerCircle = UIView()
  /// A label that displays the title from the model.
  public let titleLabel = UILabel()

  let itemVM: RadioItemVM<ID>
  var groupVM: RadioGroupVM<ID> {
    didSet {
      self.update(oldValue)
    }
  }
  var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else { return }
      if self.isSelected {
        self.select()
      } else {
        self.deselect()
      }
    }
  }

  // MARK: Initialization

  init(
    isSelected: Bool,
    groupVM: RadioGroupVM<ID>,
    itemVM: RadioItemVM<ID>
  ) {
    self.groupVM = groupVM
    self.itemVM = itemVM
    self.isSelected = isSelected

    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.radioView)
    self.radioView.addSubview(self.innerCircle)
    self.addSubview(self.titleLabel)

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  // MARK: Style

  private func style() {
    Self.Style.mainView(
      self,
      itemVM: self.itemVM,
      groupVM: self.groupVM
    )
    Self.Style.radioView(
      self.radioView,
      itemVM: self.itemVM,
      groupVM: self.groupVM,
      isSelected: self.isSelected
    )
    Self.Style.innerCircle(
      self.innerCircle,
      itemVM: self.itemVM,
      groupVM: self.groupVM,
      isSelected: self.isSelected
    )
    Self.Style.titleLabel(
      self.titleLabel,
      itemVM: self.itemVM,
      groupVM: self.groupVM
    )
  }

  // MARK: Layout

  private func layout() {
    self.radioView.size(self.groupVM.circleSize)
    self.radioView.leading()
    self.radioView.centerVertically()
    self.radioView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
    self.radioView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true

    self.innerCircle.size(self.groupVM.innerCircleSize)
    self.innerCircle.center(in: self.radioView)

    self.titleLabel.after(self.radioView, padding: 8)
    self.titleLabel.trailing()
    self.titleLabel.centerVertically()
    self.titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
    self.titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true
  }

  // MARK: Update

  func update(_ oldModel: RadioGroupVM<ID>) {
    self.style()
  }

  // MARK: Selection

  private func select() {
    self.radioView.layer.borderColor = self.groupVM.radioItemColor(
      for: self.itemVM,
      isSelected: true
    ).uiColor.cgColor
    self.innerCircle.backgroundColor = self.groupVM.radioItemColor(
      for: self.itemVM,
      isSelected: true
    ).uiColor

    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [.curveEaseOut],
      animations: {
        self.innerCircle.transform = CGAffineTransform.identity
        self.innerCircle.alpha = 1
      },
      completion: nil
    )
  }

  private func deselect() {
    self.radioView.layer.borderColor = self.groupVM.radioItemColor(
      for: self.itemVM,
      isSelected: false
    ).uiColor.cgColor

    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [.curveEaseOut],
      animations: {
        self.innerCircle.transform = .init(scaleX: 0.1, y: 0.1)
        self.innerCircle.alpha = 0
      },
      completion: nil
    )
  }

  // MARK: UIView Methods

  public override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: Helpers

  @objc private func handleTraitChanges() {
    Self.Style.radioView(
      self.radioView,
      itemVM: self.itemVM,
      groupVM: self.groupVM,
      isSelected: self.isSelected
    )
  }
}

// MARK: - Style Helpers

extension RadioGroupItemView {
  fileprivate enum Style {
    static func mainView(
      _ view: UIView,
      itemVM: RadioItemVM<ID>,
      groupVM: RadioGroupVM<ID>
    ) {
      view.isUserInteractionEnabled = groupVM.isItemEnabled(itemVM)
    }

    static func radioView(
      _ view: UIView,
      itemVM: RadioItemVM<ID>,
      groupVM: RadioGroupVM<ID>,
      isSelected: Bool
    ) {
      view.layer.cornerRadius = groupVM.circleSize / 2
      view.layer.borderWidth = groupVM.lineWidth
      view.layer.borderColor = groupVM.radioItemColor(for: itemVM, isSelected: isSelected).uiColor.cgColor
      view.backgroundColor = .clear
    }

    static func innerCircle(
      _ view: UIView,
      itemVM: RadioItemVM<ID>,
      groupVM: RadioGroupVM<ID>,
      isSelected: Bool
    ) {
      view.layer.cornerRadius = groupVM.innerCircleSize / 2
      view.backgroundColor = groupVM.radioItemColor(for: itemVM, isSelected: isSelected).uiColor
      view.alpha = isSelected ? 1 : 0
      view.transform = isSelected ? .identity : .init(scaleX: 0.1, y: 0.1)
    }

    static func titleLabel(
      _ label: UILabel,
      itemVM: RadioItemVM<ID>,
      groupVM: RadioGroupVM<ID>
    ) {
      label.text = itemVM.title
      label.font = groupVM.preferredFont(for: itemVM.id).uiFont
      label.textColor = groupVM.textColor(for: itemVM).uiColor
      label.numberOfLines = 0
    }
  }
}
