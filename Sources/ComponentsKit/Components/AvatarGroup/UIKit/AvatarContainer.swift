import AutoLayout
import UIKit

final class AvatarContainer: UIView {
  // MARK: - Properties

  let avatar: UKAvatar
  var groupVM: AvatarGroupVM
  var avatarConstraints = LayoutConstraints()

  // MARK: - Initialization

  init(avatarVM: AvatarVM, groupVM: AvatarGroupVM) {
    self.avatar = UKAvatar(model: avatarVM)
    self.groupVM = groupVM

    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  func setup() {
    self.addSubview(self.avatar)
  }

  // MARK: - Style

  func style() {
    Self.Style.mainView(self, model: self.groupVM)
  }

  // MARK: - Layout

  func layout() {
    self.avatarConstraints = .merged {
      self.avatar.allEdges(self.groupVM.padding)
      self.avatar.height(self.groupVM.avatarHeight)
      self.avatar.width(self.groupVM.avatarWidth)
    }

    self.avatarConstraints.height?.priority = .defaultHigh
    self.avatarConstraints.width?.priority = .defaultHigh
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.groupVM.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: - Update

  func update(avatarVM: AvatarVM, groupVM: AvatarGroupVM) {
    let oldModel = self.groupVM
    self.groupVM = groupVM

    if self.groupVM.size != oldModel.size {
      self.avatarConstraints.top?.constant = groupVM.padding
      self.avatarConstraints.leading?.constant = groupVM.padding
      self.avatarConstraints.bottom?.constant = -groupVM.padding
      self.avatarConstraints.trailing?.constant = -groupVM.padding
      self.avatarConstraints.height?.constant = groupVM.avatarHeight
      self.avatarConstraints.width?.constant = groupVM.avatarWidth

      self.setNeedsLayout()
    }

    self.avatar.model = avatarVM
    self.style()
  }
}

// MARK: - Style Helpers

extension AvatarContainer {
  @MainActor
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: AvatarGroupVM) {
      view.backgroundColor = model.borderColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value(for: view.bounds.height)
    }
  }
}
