import SwiftUI

/// A SwiftUI component that displays a progress bar.
public struct SUProgressBar: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: ProgressBarVM
  /// A binding to control the current value.
  @Binding public var currentValue: CGFloat

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: A binding to the current value.
  ///   - model: A model that defines the appearance properties.
  public init(
    currentValue: Binding<CGFloat>,
    model: ProgressBarVM = .init()
  ) {
    self._currentValue = currentValue
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    GeometryReader { geometry in
      switch self.model.style {
      case .light:
        HStack(spacing: 4) {
          RoundedRectangle(cornerRadius: self.model.cornerRadius(forHeight: self.model.barHeight))
            .foregroundStyle(self.model.barColor.color)
            .frame(width: geometry.size.width * self.progress, height: self.model.barHeight)
          RoundedRectangle(cornerRadius: self.model.cornerRadius(forHeight: self.model.barHeight))
            .foregroundStyle(self.model.backgroundColor.color)
            .frame(width: geometry.size.width * (1 - self.progress))
        }
        .animation(
          Animation.easeInOut(duration: 0.3),
          value: self.progress
        )

      case .filled:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.cornerRadius(forHeight: self.model.barHeight))
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width)

          RoundedRectangle(cornerRadius: self.model.innerCornerRadius(forHeight: self.model.barHeight))
            .foregroundStyle(self.model.color.contrast.color)
            .frame(width: (geometry.size.width - self.model.innerBarPadding * 2) * self.progress)
            .padding(.vertical, self.model.innerBarPadding)
            .padding(.horizontal, self.model.innerBarPadding)
        }
        .animation(
          Animation.easeInOut(duration: 0.3),
          value: self.progress
        )

      case .striped:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.cornerRadius(forHeight: self.model.barHeight))
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width)

          RoundedRectangle(cornerRadius: self.model.innerCornerRadius(forHeight: self.model.barHeight))
            .foregroundStyle(self.model.color.contrast.color)
            .frame(width: (geometry.size.width - self.model.innerBarPadding * 2) * self.progress)
            .padding(.vertical, self.model.innerBarPadding)
            .padding(.horizontal, self.model.innerBarPadding)

          StripesShape(model: self.model)
            .foregroundStyle(self.model.color.main.color)
            .cornerRadius(self.model.cornerRadius(forHeight: self.model.barHeight))
            .clipped()
        }
        .animation(
          Animation.easeInOut(duration: 0.3),
          value: self.progress
        )

      }
    }
    .animation(.spring, value: self.progress)
    .frame(height: self.model.barHeight)
    .onAppear {
      self.model.validateMinMaxValues()
    }
  }
}

// MARK: - Helpers

struct StripesShape: Shape {
  var model: ProgressBarVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
