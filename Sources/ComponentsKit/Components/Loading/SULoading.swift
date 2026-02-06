import Combine
import SwiftUI

/// A SwiftUI component that shows that a task is in progress.
public struct SULoading: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: LoadingVM

  @State private var rotationAngle: CGFloat = 0.0

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: LoadingVM = .init()) {
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    GeometryReader { geometry in
      Path { path in
        path.addArc(
          center: self.model.center(size: geometry.size),
          radius: self.model.radius(size: geometry.size),
          startAngle: .radians(0),
          endAngle: .radians(2 * .pi),
          clockwise: true
        )
      }
      .trim(from: 0, to: 0.75)
      .stroke(
        self.model.color.main.color,
        style: StrokeStyle(
          lineWidth: self.model.loadingLineWidth,
          lineCap: self.model.lineCap.cgLineCap,
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
      .onAppear {
        DispatchQueue.main.async {
          self.rotationAngle = 2 * .pi
        }
      }
    }
    .frame(
      width: self.model.preferredSize?.width,
      height: self.model.preferredSize?.height,
      alignment: .center
    )
  }
}
