import ComponentsKit
import SwiftUI
import UIKit

struct CardPreview: View {
  @State private var model = CardVM()

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKCard(model: self.model, content: self.ukCardContent)
          .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUCard(model: self.model, content: self.suCardContent)
      }
      Form {
        AnimationScalePicker(selection: self.$model.animationScale)
        Picker("Background Color", selection: self.$model.backgroundColor) {
          Text("Background").tag(UniversalColor.background)
          Text("Secondary Background").tag(UniversalColor.secondaryBackground)
          Text("Accent Background").tag(UniversalColor.accentBackground)
          Text("Success Background").tag(UniversalColor.successBackground)
          Text("Warning Background").tag(UniversalColor.warningBackground)
          Text("Danger Background").tag(UniversalColor.dangerBackground)
        }
        Picker("Border Color", selection: self.$model.borderColor) {
          Text("Divider").tag(UniversalColor.divider)
          Text("Primary").tag(UniversalColor.primary)
          Text("Accent").tag(UniversalColor.accent)
          Text("Success").tag(UniversalColor.success)
          Text("Warning").tag(UniversalColor.warning)
          Text("Danger").tag(UniversalColor.danger)
          Text("Custom").tag(UniversalColor.universal(.uiColor(.systemPurple)))
        }
        BorderWidthPicker(selection: self.$model.borderWidth)
        Picker("Content Paddings", selection: self.$model.contentPaddings) {
          Text("12px").tag(Paddings(padding: 12))
          Text("16px").tag(Paddings(padding: 16))
          Text("20px").tag(Paddings(padding: 20))
        }
        ContainerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom 4px").tag(ContainerRadius.custom(4))
        }
        Picker("Shadow", selection: self.$model.shadow) {
          Text("None").tag(Shadow.none)
          Text("Small").tag(Shadow.small)
          Text("Medium").tag(Shadow.medium)
          Text("Large").tag(Shadow.large)
          Text("Custom").tag(Shadow.custom(20.0, .zero, UniversalColor.accentBackground))
        }
        Toggle("Tappable", isOn: self.$model.isTappable)
      }
    }
  }

  // MARK: - Helpers

  private func ukCardContent() -> UIView {
    let titleLabel = UILabel()
    titleLabel.text = "Card"
    titleLabel.font = UniversalFont.mdHeadline.uiFont
    titleLabel.textColor = UniversalColor.foreground.uiColor
    titleLabel.numberOfLines = 0

    let subtitleLabel = UILabel()
    subtitleLabel.text = "Card is a container for text, images, and other content."
    subtitleLabel.font = UniversalFont.mdBody.uiFont
    subtitleLabel.textColor = UniversalColor.secondaryForeground.uiColor
    subtitleLabel.numberOfLines = 0

    let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    stackView.axis = .vertical
    stackView.spacing = 8

    return stackView
  }

  private func suCardContent() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Card")
        .foregroundStyle(UniversalColor.foreground.color)
        .font(UniversalFont.mdHeadline.font)

      Text("Card is a container for text, images, and other content.")
        .foregroundStyle(UniversalColor.secondaryForeground.color)
        .font(UniversalFont.mdBody.font)
    }
  }
}

#Preview {
  CardPreview()
}
