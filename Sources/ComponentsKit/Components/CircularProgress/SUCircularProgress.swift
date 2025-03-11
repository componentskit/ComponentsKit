import SwiftUI

/// A SwiftUI component that displays a circular progress.
public struct SUCircularProgress: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: CircularProgressVM

  /// The current progress value.
  public var currentValue: CGFloat

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: Current progress.
  ///   - model: A model that defines the appearance properties.
  public init(
    currentValue: CGFloat = 0,
    model: CircularProgressVM = .init()
  ) {
    self.currentValue = currentValue
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    ZStack {
      // Background part
      Group {
        switch self.model.style {
        case .light:
          self.lightBackground
        case .striped:
          self.stripedBackground
        }
      }
      .frame(
        width: self.model.preferredSize.width,
        height: self.model.preferredSize.height
      )

      // Foreground part
      Path { path in
        path.addArc(
          center: self.model.center,
          radius: self.model.radius,
          startAngle: .radians(0),
          endAngle: .radians(2 * .pi),
          clockwise: false
        )
      }
      .trim(from: 0, to: self.progress)
      .stroke(
        self.model.color.main.color,
        style: StrokeStyle(
          lineWidth: self.model.circularLineWidth,
          lineCap: .round
        )
      )
      .rotationEffect(.degrees(-90))
      .frame(
        width: self.model.preferredSize.width,
        height: self.model.preferredSize.height
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

  // MARK: - Subviews

  var lightBackground: some View {
    Path { path in
      path.addArc(
        center: self.model.center,
        radius: self.model.radius,
        startAngle: .radians(0),
        endAngle: .radians(2 * .pi),
        clockwise: false
      )
    }
    .stroke(
      self.model.color.background.color,
      lineWidth: self.model.circularLineWidth
    )
  }

  var stripedBackground: some View {
    Path { path in
      path.addArc(
        center: self.model.center,
        radius: self.model.radius,
        startAngle: .radians(0),
        endAngle: .radians(2 * .pi),
        clockwise: false
      )
    }
    .trim(
      from: self.model.backgroundArcStart(for: self.progress),
      to: self.model.backgroundArcEnd(for: self.progress)
    )
    .stroke(
      .clear,
      style: StrokeStyle(
        lineWidth: self.model.circularLineWidth,
        lineCap: .round
      )
    )
    .overlay {
      StripesShapeCircularProgress(model: self.model)
        .foregroundColor(self.model.color.main.color)
        .mask {
          Path { maskPath in
            maskPath.addArc(
              center: self.model.center,
              radius: self.model.radius,
              startAngle: .radians(0),
              endAngle: .radians(2 * .pi),
              clockwise: false
            )
          }
          .trim(
            from: self.model.backgroundArcStart(for: self.progress),
            to: self.model.backgroundArcEnd(for: self.progress)
          )
          .stroke(
            style: StrokeStyle(
              lineWidth: self.model.circularLineWidth,
              lineCap: .round
            )
          )
        }
    }
    .rotationEffect(.degrees(-90))
  }
}

// MARK: - Helpers

struct StripesShapeCircularProgress: Shape, @unchecked Sendable {
  var model: CircularProgressVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
