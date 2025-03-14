import ComponentsKit
import SwiftUI
import UIKit

struct ModalPreviewHelpers {
  // MARK: - Enums

  enum ContentBody {
    case shortText
    case longText
  }
  enum ContentFooter {
    case button
    case buttonAndCheckbox
  }

  // MARK: - Preview Sections

  struct ContentSection<VM: ModalVM>: View {
    @Binding var model: VM
    @Binding var hasHeader: Bool
    @Binding var contentBody: ContentBody
    @Binding var contentFooter: ContentFooter?

    var body: some View {
      Section("Content") {
        Picker("Header", selection: self.$hasHeader) {
          Text("Text").tag(true)
          Text("None").tag(false)
        }
        Picker("Body", selection: self.$contentBody) {
          Text("Short Text").tag(ContentBody.shortText)
          Text("Long Text").tag(ContentBody.longText)
        }
        Picker("Footer", selection: .init(
          get: {
            return self.contentFooter
          },
          set: { newValue in
            if newValue == nil {
              self.model.closesOnOverlayTap = true
            }
            self.contentFooter = newValue
          }
        )) {
          Text("Button").tag(ContentFooter.button)
          Text("Button and Checkbox").tag(ContentFooter.buttonAndCheckbox)
          Text("None").tag(Optional<ContentFooter>.none)
        }
      }
    }
  }

  struct PropertiesSection<VM: ModalVM, Pickers: View>: View {
    @Binding var model: VM
    @Binding var footer: ContentFooter?
    @ViewBuilder var additionalPickers: () -> Pickers

    var body: some View {
      Section("Properties") {
        Picker("Background Color", selection: self.$model.backgroundColor) {
          Text("Default").tag(Optional<UniversalColor>.none)
          Text("Accent Background").tag(UniversalColor.accentBackground)
          Text("Success Background").tag(UniversalColor.successBackground)
          Text("Warning Background").tag(UniversalColor.warningBackground)
          Text("Danger Background").tag(UniversalColor.dangerBackground)
        }
        BorderWidthPicker(selection: self.$model.borderWidth)
        Toggle("Closes On Overlay Tap", isOn: self.$model.closesOnOverlayTap)
          .disabled(self.footer == nil)
        Picker("Outer Paddings", selection: self.$model.outerPaddings) {
          Text("12px").tag(Paddings(padding: 12))
          Text("16px").tag(Paddings(padding: 16))
          Text("20px").tag(Paddings(padding: 20))
        }
        Picker("Content Spacing", selection: self.$model.contentSpacing) {
          Text("8px").tag(CGFloat(8))
          Text("12px").tag(CGFloat(12))
          Text("16px").tag(CGFloat(16))
        }
        Picker("Content Paddings", selection: self.$model.contentPaddings) {
          Text("12px").tag(Paddings(padding: 12))
          Text("16px").tag(Paddings(padding: 16))
          Text("20px").tag(Paddings(padding: 20))
        }
        ContainerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom 30px").tag(ContainerRadius.custom(30))
        }
        OverlayStylePicker(selection: self.$model.overlayStyle)
        Picker("Size", selection: self.$model.size) {
          Text("Small").tag(ModalSize.small)
          Text("Medium").tag(ModalSize.medium)
          Text("Large").tag(ModalSize.large)
          Text("Full").tag(ModalSize.full)
        }
        TransitionPicker(selection: self.$model.transition)
        self.additionalPickers()
      }
    }
  }

  // MARK: - Shared UI

  private static let headerTitle = "Header"
  private static let headerFont: UniversalFont = .system(size: 20, weight: .bold)

  private static let bodyShortText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
  private static let bodyLongText = """
Lorem ipsum odor amet, consectetuer adipiscing elit. Vitae vehicula pellentesque lectus orci fames. Cras suscipit dui tortor penatibus turpis ultrices. Laoreet montes adipiscing ante dapibus facilisis. Lorem per fames nec duis quis eleifend imperdiet. Tincidunt id interdum adipiscing eros dis quis platea varius. Potenti eleifend eu molestie laoreet varius sapien. Adipiscing nascetur platea penatibus curabitur tempus nibh laoreet porttitor. Augue et curabitur cras sed semper inceptos nunc montes mollis.

Lectus arcu pellentesque inceptos tempor fringilla nascetur. Erat curae convallis integer mi, quis facilisi tortor. Phasellus aliquam molestie vehicula odio in dis maximus diam elit. Rutrum gravida amet euismod feugiat fusce. Est egestas velit vulputate senectus sociosqu fringilla eget nibh. Nam pellentesque aenean mi platea tincidunt quam sem purus. Himenaeos suspendisse nec sapien habitasse ultricies maecenas libero odio. Rutrum senectus maximus ultrices, ad nam ultricies placerat.

Enim habitant laoreet inceptos scelerisque senectus, tellus molestie ut. Eros risus nibh morbi eu aenean. Velit ligula magnis aliquet at luctus. Dapibus vestibulum consectetur euismod vitae per ultrices litora quis. Aptent eleifend dapibus urna lacinia felis nisl. Sit amet fusce nullam feugiat posuere. Urna amet curae velit fermentum interdum vestibulum penatibus. Penatibus vivamus sem ultricies pellentesque congue id mattis diam. Aliquam efficitur mi gravida sollicitudin; amet imperdiet. Rutrum mollis risus justo tortor in duis cursus.
"""
  private static let bodyFont: UniversalFont = .system(size: 18, weight: .regular)

  private static let footerButtonVM = ButtonVM {
    $0.title = "Close"
    $0.isFullWidth = true
    $0.color = .primary
  }
  private static let footerCheckboxVM = CheckboxVM {
    $0.title = "Agree and continue"
  }

  // MARK: - UIKit

  static func ukHeader(hasHeader: Bool) -> UKModalController.Content? {
    guard hasHeader else {
      return nil
    }

    return { _ in
      let title = UILabel()
      title.text = self.headerTitle
      title.font = self.headerFont.uiFont
      return title
    }
  }

  static func ukBody(body: ContentBody) -> UKModalController.Content {
    return { _ in
      let subtitle = UILabel()
      switch body {
      case .shortText:
        subtitle.text = self.bodyShortText
      case .longText:
        subtitle.text = self.bodyLongText
      }
      subtitle.numberOfLines = 0
      subtitle.font = self.bodyFont.uiFont
      return subtitle
    }
  }

  static func ukFooter(footer: ContentFooter?) -> UKModalController.Content? {
    return footer.map { footer in
      return { dismiss in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16

        let button = UKButton(
          model: self.footerButtonVM,
          action: { dismiss(true) }
        )
        stackView.addArrangedSubview(button)

        switch footer {
        case .button:
          button.model.isEnabled = true
        case .buttonAndCheckbox:
          button.model.isEnabled = false
          let checkbox = UKCheckbox(
            initialValue: false,
            model: self.footerCheckboxVM,
            onValueChange: { isSelected in
              button.model.isEnabled = isSelected
            }
          )
          stackView.insertArrangedSubview(checkbox, at: 0)
        }

        return stackView
      }
    }
  }

  // MARK: - SwiftUI

  static func suHeader(hasHeader: Bool) -> some View {
    Group {
      if hasHeader {
        HStack {
          Text(self.headerTitle)
            .font(self.headerFont.font)
          Spacer()
        }
      } else {
        EmptyView()
      }
    }
  }

  static func suBody(body: ContentBody) -> some View {
    Group {
      switch body {
      case .shortText:
        Text(self.bodyShortText)
      case .longText:
        Text(self.bodyLongText)
      }
    }
    .font(self.bodyFont.font)
    .multilineTextAlignment(.leading)
  }

  static func suFooter(
    isPresented: Binding<Bool>,
    isCheckboxSelected: Binding<Bool>,
    footer: ContentFooter?
  ) -> some View {
    Group {
      switch footer {
      case .none:
        EmptyView()
      case .button:
        SUButton(model: self.footerButtonVM) {
          isPresented.wrappedValue = false
        }
      case .buttonAndCheckbox:
        VStack(alignment: .leading, spacing: 16) {
          SUCheckbox(
            isSelected: isCheckboxSelected,
            model: self.footerCheckboxVM
          )
          SUButton(model: self.footerButtonVM.updating {
            $0.isEnabled = isCheckboxSelected.wrappedValue
          }) {
            isPresented.wrappedValue = false
          }
        }
      }
    }
  }
}
