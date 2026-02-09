import SwiftUI

/// A SwiftUI component that performs an action when it is tapped by a user.
public struct SUButton: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: ButtonVM
  /// A closure that is triggered when the button is tapped.
  public var action: () -> Void

  /// A current scale effect value.
  @State public var scale: CGFloat = 1.0

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
        self.scale = self.model.animationScale.value
      }
      .onEnded { _ in
        self.scale = 1.0
      }
    )
    .disabled(!self.model.isInteractive)
    .scaleEffect(self.scale, anchor: .center)
    .animation(.easeOut(duration: 0.05), value: self.scale)
  }

  @ViewBuilder
  private var content: some View {
    switch (self.model.isLoading, self.model.imageWithLegacyFallback, self.model.imageLocation) {
    case (true, _, _) where self.model.title.isEmpty:
      SULoading(model: self.model.preferredLoadingVM)
    case (true, _, _):
      SULoading(model: self.model.preferredLoadingVM)
      Text(self.model.title)
    case (false, let image?, _) where self.model.title.isEmpty:
      ButtonImage(
        image: image,
        tintColor: self.model.foregroundColor,
        side: self.model.imageSide
      )
    case (false, let image?, .leading):
      ButtonImage(
        image: image,
        tintColor: self.model.foregroundColor,
        side: self.model.imageSide
      )
      Text(self.model.title)
    case (false, let image?, .trailing):
      Text(self.model.title)
      ButtonImage(
        image: image,
        tintColor: self.model.foregroundColor,
        side: self.model.imageSide
      )
    case (false, _, _):
      Text(self.model.title)
    }
  }
}

// MARK: - Helpers

private struct ButtonImage: View {
  let universalImage: UniversalImage
  let tintColor: UniversalColor
  let side: CGFloat

  init(
    image: UniversalImage,
    tintColor: UniversalColor,
    side: CGFloat
  ) {
    self.universalImage = image
    self.tintColor = tintColor
    self.side = side
  }

  var body: some View {
    self.universalImage.image
      .resizable()
      .scaledToFit()
      .tint(self.tintColor.color)
      .frame(width: self.side, height: self.side)
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
      .contentShape(.rect)
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
        .strokeBorder(
          self.model.borderColor?.color ?? .clear,
          lineWidth: self.model.borderWidth
        )
      }
  }
}
