import SwiftUI
import Combine

public struct SULoading: View {
  private var model: LoadingVM

  @State private var rotationAngle: CGFloat = 0.0

  @Environment(\.colorScheme) private var colorScheme

  public init(model: LoadingVM = .init()) {
    self.model = model
  }

  public var body: some View {
    Path { path in
      path.addArc(
        center: self.model.center,
        radius: self.model.radius,
        startAngle: .radians(0),
        endAngle: .radians(2 * .pi),
        clockwise: true
      )
    }
      .trim(from: 0, to: 0.75)
      .stroke(
        self.model.color.main.color(for: self.colorScheme),
        style: StrokeStyle(
          lineWidth: self.model.loadingLineWidth,
          lineCap: .round,
          lineJoin: .round,
          miterLimit: 0
        )
      )
      .rotationEffect(.radians(self.rotationAngle))
      .animation(
        .linear(duration: 1.0)
        .repeatForever(autoreverses: false),
        value: self.rotationAngle
      )
      .frame(
        width: self.model.preferredSize.width,
        height: self.model.preferredSize.height,
        alignment: .center
      )
      .onAppear {
        self.rotationAngle = 2 * .pi
      }
  }
}
