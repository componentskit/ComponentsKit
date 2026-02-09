import SwiftUI

/// A SwiftUI component that displays the progress of a task or operation in a circular form.
public struct SUCircularProgress: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: CircularProgressVM

  /// The current progress value.
  public var currentValue: CGFloat?

  private var progress: CGFloat {
    self.currentValue.map { self.model.progress(for: $0) } ?? self.model.progress
  }

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: Current progress.
  ///   - model: A model that defines the appearance properties.
  @available(*, deprecated, message: "Set `currentValue` in the model instead.")
  public init(
    currentValue: CGFloat = 0,
    model: CircularProgressVM = .init()
  ) {
    self.currentValue = currentValue
    self.model = model
  }

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: CircularProgressVM) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    ZStack {
      GeometryReader { geometry in
        // Background part
        Path { path in
          path.addArc(
            center: self.model.center(size: geometry.size),
            radius: self.model.radius(size: geometry.size),
            startAngle: .radians(self.model.startAngle),
            endAngle: .radians(self.model.endAngle),
            clockwise: false
          )
        }
        .stroke(
          self.model.color.background.color,
          style: StrokeStyle(
            lineWidth: self.model.circularLineWidth,
            lineCap: self.model.lineCap.cgLineCap
          )
        )

        // Foreground part
        Path { path in
          path.addArc(
            center: self.model.center(size: geometry.size),
            radius: self.model.radius(size: geometry.size),
            startAngle: .radians(self.model.startAngle),
            endAngle: .radians(self.model.endAngle),
            clockwise: false
          )
        }
        .trim(from: 0, to: self.progress)
        .stroke(
          self.model.color.main.color,
          style: StrokeStyle(
            lineWidth: self.model.circularLineWidth,
            lineCap: self.model.lineCap.cgLineCap
          )
        )
      }
      .frame(
        width: self.model.preferredSize?.width,
        height: self.model.preferredSize?.height
      )

      // Optional label
      if let label = self.model.label {
        Text(label)
          .font(self.model.titleFont.font)
          .foregroundColor(self.model.color.main.color)
      }
    }
    .animation(
      Animation.linear(duration: self.model.animationDuration),
      value: self.progress
    )
  }
}
