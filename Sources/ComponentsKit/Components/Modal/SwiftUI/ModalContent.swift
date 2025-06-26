import SwiftUI

struct ModalContent<VM: ModalVM, Header: View, Body: View, Footer: View>: View {
  let model: VM

  @ViewBuilder let contentHeader: () -> Header
  @ViewBuilder let contentBody: () -> Body
  @ViewBuilder let contentFooter: () -> Footer

  @State private var headerSize: CGSize = .zero
  @State private var bodySize: CGSize = .zero
  @State private var footerSize: CGSize = .zero

  init(
    model: VM,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer
  ) {
    self.model = model
    self.contentHeader = header
    self.contentBody = body
    self.contentFooter = footer
  }

  var body: some View {
    VStack(spacing: self.model.contentSpacing) {
      self.contentHeader()
        .observeSize {
          self.headerSize = $0
        }
        .padding(.top, self.model.contentPaddings.top)
        .padding(.leading, self.model.contentPaddings.leading)
        .padding(.trailing, self.model.contentPaddings.trailing)

      ScrollView {
        self.contentBody()
          .padding(.leading, self.model.contentPaddings.leading)
          .padding(.trailing, self.model.contentPaddings.trailing)
          .observeSize {
            self.bodySize = $0
          }
          .padding(.top, self.bodyTopPadding)
          .padding(.bottom, self.bodyBottomPadding)
      }
      .frame(maxWidth: .infinity, maxHeight: self.scrollViewMaxHeight)
      .disableScrollWhenContentFits()

      self.contentFooter()
        .observeSize {
          self.footerSize = $0
        }
        .padding(.leading, self.model.contentPaddings.leading)
        .padding(.trailing, self.model.contentPaddings.trailing)
        .padding(.bottom, self.model.contentPaddings.bottom)
    }
    .frame(maxWidth: self.model.size.maxWidth, alignment: .leading)
    .background(self.model.preferredBackgroundColor.color)
    .clipShape(RoundedRectangle(cornerRadius: self.model.cornerRadius.value))
    .overlay(
      RoundedRectangle(cornerRadius: self.model.cornerRadius.value)
        .strokeBorder(UniversalColor.divider.color, lineWidth: self.model.borderWidth.value)
    )
    .padding(self.model.outerPaddings.edgeInsets)
  }

  private var bodyTopPadding: CGFloat {
    return self.headerSize.height > 0 ? 0 : self.model.contentPaddings.top
  }
  private var bodyBottomPadding: CGFloat {
    return self.footerSize.height > 0 ? 0 : self.model.contentPaddings.bottom
  }
  private var scrollViewMaxHeight: CGFloat {
    return self.bodySize.height + self.bodyTopPadding + self.bodyBottomPadding
  }
}
