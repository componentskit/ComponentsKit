import SwiftUI

/// A SwiftUI component that visually represents the progress of a task or process using a horizontal bar.
public struct SUProgressBar: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: ProgressBarVM
  /// The current progress value.
  public var currentValue: CGFloat?

  private var progress: CGFloat {
    self.currentValue.map { self.model.progress(for: $0) } ?? self.model.progress
  }

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: ProgressBarVM) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    GeometryReader { geometry in
      switch self.model.style {
      case .light:
        HStack(spacing: self.model.lightBarSpacing) {
          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.progressHeight))
            .foregroundStyle(self.model.barColor.color)
            .frame(width: geometry.size.width * self.progress)
          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.backgroundHeight))
            .foregroundStyle(self.model.backgroundColor.color)
            .frame(width: geometry.size.width * (1 - self.progress))
        }

      case .filled:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.backgroundHeight))
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width)

          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.progressHeight))
            .foregroundStyle(self.model.color.contrast.color)
            .frame(width: (geometry.size.width - self.model.progressPadding * 2) * self.progress)
            .padding(.vertical, self.model.progressPadding)
            .padding(.horizontal, self.model.progressPadding)
        }

      case .striped:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.backgroundHeight))
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width)

          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.progressHeight))
            .foregroundStyle(self.model.color.contrast.color)
            .frame(width: (geometry.size.width - self.model.progressPadding * 2) * self.progress)
            .padding(.vertical, self.model.progressPadding)
            .padding(.horizontal, self.model.progressPadding)

          StripesShape(model: self.model)
            .foregroundStyle(self.model.color.main.color)
            .cornerRadius(self.model.cornerRadius(for: self.model.progressHeight))
            .frame(width: (geometry.size.width - self.model.progressPadding * 2) * self.progress)
            .padding(.vertical, self.model.progressPadding)
            .padding(.horizontal, self.model.progressPadding)
        }
      }
    }
    .animation(
      Animation.linear(duration: self.model.animationDuration),
      value: self.progress
    )
    .frame(height: self.model.backgroundHeight)
    .onAppear {
      self.model.validateMinMaxValues()
    }
  }
}

// MARK: - Helpers

struct StripesShape: Shape, @unchecked Sendable {
  var model: ProgressBarVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
