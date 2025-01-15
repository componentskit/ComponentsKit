import ComponentsKit
import SwiftUI
import UIKit

struct ProgressBarPreview: View {
  @State private var model = Self.initialModel
  @State private var currentValue: CGFloat = Self.initialValue

  private let progressBar = UKProgressBar(initialValue: Self.initialValue, model: Self.initialModel)

  private let timer = Timer
    .publish(every: 0.1, on: .main, in: .common)
    .autoconnect()
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        self.progressBar
          .preview
          .onAppear {
            self.progressBar.currentValue = self.currentValue
            self.progressBar.model = Self.initialModel
          }
          .onChange(of: self.model) { newValue in
            self.progressBar.model = newValue
          }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUProgressBar(currentValue: self.$currentValue, model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 2px").tag(ComponentRadius.custom(2))
        }
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Light").tag(ProgressBarVM.Style.light)
          Text("Filled").tag(ProgressBarVM.Style.filled)
          Text("Striped").tag(ProgressBarVM.Style.striped)
        }
      }
    }
    .onReceive(self.timer) { _ in
      if self.currentValue < self.model.maxValue {
        self.currentValue += (self.model.maxValue - self.model.minValue) / 100
      } else {
        self.currentValue = self.model.minValue
      }
      
      self.progressBar.currentValue = self.currentValue
    }
  }
  
  // MARK: - Helpers
  
  private static var initialValue: Double {
    return 0.0
  }
  private static var initialModel: ProgressBarVM {
    return .init()
  }
}

#Preview {
  ProgressBarPreview()
}
