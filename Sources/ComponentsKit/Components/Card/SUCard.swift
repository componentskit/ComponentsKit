import SwiftUI

/// A SwiftUI component that serves as a container for provided content.
///
/// - Example:
/// ```swift
/// SUCard(
///   model: .init(),
///   content: {
///     Text("This is the content of the card.")
///   }
/// )
/// ```
public struct SUCard<Content: View>: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public let model: CardVM
  /// A closure that is triggered when the card is tapped.
  public var onTap: () -> Void

  /// A current scale effect value.
  @State public var scale: CGFloat = 1.0

  @ViewBuilder private let content: () -> Content
  @State private var contentSize: CGSize = .zero

  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - content: The content that is displayed in the card.
  public init(
    model: CardVM = .init(),
    content: @escaping () -> Content,
    onTap: @escaping () -> Void = {}
  ) {
    self.model = model
    self.content = content
    self.onTap = onTap
  }

  // MARK: - Body

  public var body: some View {
    self.content()
      .padding(self.model.contentPaddings.edgeInsets)
      .cardBackground(
        shape: RoundedRectangle(cornerRadius: self.model.cornerRadius.value),
        model: self.model
      )
      .shadow(self.model.shadow)
      .observeSize { self.contentSize = $0 }
      .contentShape(.rect)
      .onTapGesture {
        guard self.model.isTappable else { return }
        self.onTap()
      }
      .simultaneousGesture(
        DragGesture(minimumDistance: 0.0)
          .onChanged { _ in
            self.scale = self.model.animationScale.value
          }
          .onEnded { _ in
            self.scale = 1.0
          },
        isEnabled: self.model.isTapAnimationEnabled
      )
      .scaleEffect(self.scale, anchor: .center)
      .animation(.easeOut(duration: 0.05), value: self.scale)
  }
}

extension View {
  @ViewBuilder
  fileprivate func cardBackground<BackgroundShape: InsettableShape>(
    shape: BackgroundShape,
    model: CardVM
  ) -> some View {
    switch model.backgroundStyle {
    case .solid:
      self.background(model.backgroundColor?.color)
        .clipShape(shape)
        .overlay(
          shape
            .strokeBorder(model.borderColor.color, lineWidth: model.borderWidth.value)
        )
    case .blur:
      self
        .background {
          shape
            .fill(.thinMaterial)
            .overlay {
              shape.strokeBorder(model.borderColor.color, lineWidth: model.borderWidth.value)
            }
        }
        .background(model.backgroundColor?.color)
        .clipShape(shape)
    case .liquidGlass:
      if #available(iOS 26.0, *) {
        self
          .overlay {
            shape.strokeBorder(model.borderColor.color, lineWidth: model.borderWidth.value)
          }
          .glassEffect(
            .regular
              .tint(model.backgroundColor?.color)
              .interactive(model.isTappable),
            in: shape
          )
      } else {
        self
      }
    }
  }
}
