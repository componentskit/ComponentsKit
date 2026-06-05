import SwiftUI

extension View {
  @ViewBuilder
  func componentBackground<BackgroundShape: InsettableShape>(
    shape: BackgroundShape,
    backgroundStyle: BackgroundStyle,
    backgroundColor: Color?,
    borderColor: Color,
    borderWidth: CGFloat,
    isGlassInteractive: Bool = true
  ) -> some View {
    switch backgroundStyle {
    case .solid:
      self
        .background(backgroundColor ?? .clear)
        .clipShape(shape)
        .overlay {
          shape.strokeBorder(borderColor, lineWidth: borderWidth)
        }
    case .blur:
      self
        .background {
          shape
            .fill(.thinMaterial)
            .overlay {
              shape.strokeBorder(borderColor, lineWidth: borderWidth)
            }
        }
        .background(backgroundColor)
        .clipShape(shape)
    case .liquidGlass:
      if #available(iOS 26.0, *) {
        self
          .overlay {
            shape.strokeBorder(borderColor, lineWidth: borderWidth)
          }
          .glassEffect(
            .regular
              .tint(backgroundColor)
              .interactive(isGlassInteractive),
            in: shape
          )
      } else {
        self
      }
    }
  }
}
