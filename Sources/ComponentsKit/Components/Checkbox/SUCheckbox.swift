import SwiftUI

/// A SwiftUI component that can be selected by a user.
public struct SUCheckbox: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: CheckboxVM

  /// A Binding Boolean value indicating whether the checkbox is selected.
  @Binding public var isSelected: Bool

  @State private var checkmarkStroke: CGFloat
  @State private var borderOpacity: CGFloat

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - isSelected: A Binding Boolean value indicating whether the checkbox is selected.
  ///   - model: A model that defines the appearance properties.
  public init(
    isSelected: Binding<Bool>,
    model: CheckboxVM = .init()
  ) {
    self._isSelected = isSelected
    self.model = model
    self.checkmarkStroke = isSelected.wrappedValue ? 1.0 : 0.0
    self.borderOpacity = isSelected.wrappedValue ? 0.0 : 1.0
  }

  // MARK: Body

  public var body: some View {
    HStack(spacing: self.model.spacing) {
      ZStack {
        self.model.backgroundColor.color
          .clipShape(
            RoundedRectangle(cornerRadius: self.model.checkboxCornerRadius)
          )
          .scaleEffect(self.isSelected ? 1.0 : 0.1)
          .opacity(self.isSelected ? 1.0 : 0.0)
          .animation(
            .easeInOut(duration: CheckboxAnimationDurations.background),
            value: self.isSelected
          )

        Path(self.model.checkmarkPath)
          .trim(from: 0, to: self.checkmarkStroke)
          .stroke(style: StrokeStyle(
            lineWidth: self.model.checkmarkLineWidth,
            lineCap: .round,
            lineJoin: .round
          ))
          .foregroundStyle(self.model.foregroundColor.color)
      }
      .overlay {
        RoundedRectangle(cornerRadius: self.model.checkboxCornerRadius)
          .strokeBorder(
            self.model.borderColor.color,
            lineWidth: self.model.borderWidth
          )
          .opacity(self.borderOpacity)
      }
      .frame(
        width: self.model.checkboxSide,
        height: self.model.checkboxSide,
        alignment: .center
      )

      if let title = self.model.title {
        Text(title)
          .foregroundStyle(self.model.titleColor.color)
          .font(self.model.titleFont.font)
      }
    }
    .onTapGesture {
      self.isSelected.toggle()
    }
    .disabled(!self.model.isEnabled)
    .onChange(of: self.isSelected) { isSelected in
      if isSelected {
        withAnimation(
          .linear(duration: CheckboxAnimationDurations.checkmarkStroke)
          .delay(CheckboxAnimationDurations.checkmarkStrokeDelay)
        ) {
          self.checkmarkStroke = 1.0
        }
        withAnimation(
          .linear(duration: CheckboxAnimationDurations.borderOpacity)
          .delay(CheckboxAnimationDurations.selectedBorderDelay)
        ) {
          self.borderOpacity = 0.0
        }
      } else {
        self.checkmarkStroke = 0.0
        withAnimation(
          .linear(duration: CheckboxAnimationDurations.borderOpacity)
        ) {
          self.borderOpacity = 1.0
        }
      }
    }
  }
}
