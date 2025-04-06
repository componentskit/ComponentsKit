import SwiftUI

/// A SwiftUI component that performs an action when it is tapped by a user.
public struct SUButton: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: ButtonVM
  /// A closure that is triggered when the button is tapped.
  public var action: () -> Void

  /// A Boolean value indicating whether the button is pressed.
  @State public var isPressed: Bool = false

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - action: A closure that is triggered when the button is tapped.
  public init(
    model: ButtonVM,
    action: @escaping () -> Void = {}
  ) {
    self.model = model
    self.action = action
  }

  // MARK: Body

  public var body: some View {
    Button(action: self.action) {
      HStack(spacing: self.model.contentSpacing) {
        self.content
      }
    }
    .buttonStyle(CustomButtonStyle(model: self.model))
    .simultaneousGesture(DragGesture(minimumDistance: 0.0)
      .onChanged { _ in
        self.isPressed = true
      }
      .onEnded { _ in
        self.isPressed = false
      }
    )
    .disabled(!self.model.isInteractive)
    .scaleEffect(
      self.isPressed ? self.model.animationScale.value : 1,
      anchor: .center
    )
  }

  @ViewBuilder
  private var content: some View {
    switch (self.model.isLoading, self.model.image, self.model.imageLocation) {
    case (true, _, _) where self.model.title.isEmpty:
      SULoading(model: self.model.preferredLoadingVM)
    case (true, _, _):
      SULoading(model: self.model.preferredLoadingVM)
      Text(self.model.title)
    case (false, let uiImage?, .leading):
      if self.model.title.isEmpty {
        ButtonImageView(image: uiImage, size: self.model.height * 0.6)
      } else {
        ButtonImageView(image: uiImage, size: self.model.height * 0.6)
        Text(self.model.title)
      }
    case (false, let uiImage?, .trailing):
      if self.model.title.isEmpty {
        ButtonImageView(image: uiImage, size: self.model.height * 0.6)
      } else {
        Text(self.model.title)
        ButtonImageView(image: uiImage, size: self.model.height * 0.6)
      }
    default:
      Text(self.model.title)
    }
  }
}

struct ButtonImageView: View {
  let image: UIImage
  let size: CGFloat

  var body: some View {
    Image(uiImage: self.image)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: self.size, height: self.size)
  }
}

private struct CustomButtonStyle: SwiftUI.ButtonStyle {
  let model: ButtonVM

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(self.model.preferredFont.font)
      .lineLimit(1)
      .padding(.horizontal, self.model.horizontalPadding)
      .frame(maxWidth: self.model.width)
      .frame(height: self.model.height)
      .foregroundStyle(self.model.foregroundColor.color)
      .background(self.model.backgroundColor?.color ?? .clear)
      .clipShape(
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
      )
      .overlay {
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
        .stroke(
          self.model.borderColor?.color ?? .clear,
          lineWidth: self.model.borderWidth
        )
      }
  }
}
