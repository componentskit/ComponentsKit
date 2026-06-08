import SwiftUI

/// A SwiftUI component that displays a group of radio buttons, allowing users to select one option from multiple choices.
public struct SURadioGroup<ID: Hashable & Sendable>: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: RadioGroupVM<ID>

  /// A Binding value to control the selected identifier.
  @Binding public var selectedId: ID?

  @State private var viewSizes: [ID: CGSize] = [:]
  @State private var tappingId: ID?

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - selectedId: A binding to the selected identifier.
  ///   - model: A model that defines the appearance properties.
  public init(
    selectedId: Binding<ID?>,
    model: RadioGroupVM<ID>
  ) {
    self._selectedId = selectedId
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    VStack(alignment: .leading, spacing: self.model.spacing) {
      ForEach(self.model.items) { item in
        HStack(spacing: 8) {
          ZStack {
            Circle()
              .strokeBorder(
                self.model.radioItemColor(for: item, isSelected: self.selectedId == item.id).color,
                lineWidth: self.model.lineWidth
              )
              .frame(width: self.model.circleSize, height: self.model.circleSize)
            if self.selectedId == item.id {
              Circle()
                .fill(
                  self.model.radioItemColor(for: item, isSelected: true).color
                )
                .frame(width: self.model.innerCircleSize, height: self.model.innerCircleSize)
                .transition(.scale)
            }
          }
          .animation(.easeOut(duration: 0.2), value: self.selectedId)
          .scaleEffect(self.tappingId == item.id ? self.model.animationScale.value : 1.0)
          Text(item.title)
            .font(self.model.preferredFont(for: item.id).font)
            .foregroundColor(self.model.textColor(for: item).color)
        }
        .background(
          GeometryReader { proxy in
            Color.clear
              .onAppear {
                self.viewSizes[item.id] = proxy.size
              }
              .onChange(of: proxy.size) { value in
                self.viewSizes[item.id] = value
              }
          }
        )
        .simultaneousGesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in
              self.tappingId = item.id
            }
            .onEnded { gesture in
              self.tappingId = nil

              if let size = self.viewSizes[item.id],
                 CGRect(origin: .zero, size: size).contains(gesture.location) {
                self.selectedId = item.id
              }
            }
        )
        .disabled(!item.isEnabled || !self.model.isEnabled)
      }
    }
  }
}
