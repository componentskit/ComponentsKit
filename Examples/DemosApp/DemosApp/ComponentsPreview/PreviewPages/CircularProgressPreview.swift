import ComponentsKit
import SwiftUI
import UIKit

struct CircularProgressPreview: View {
  @State private var model = Self.initialModel
  
  private let circularProgress = UKCircularProgress(model: Self.initialModel)
  
  private let timer = Timer
    .publish(every: 0.5, on: .main, in: .common)
    .autoconnect()
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        self.circularProgress
          .preview
          .onAppear {
            self.circularProgress.model = Self.initialModel
          }
          .onChange(of: model) { newModel in
            self.circularProgress.model = newModel
          }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUCircularProgress(model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        CaptionFontPicker(selection: self.$model.font)
        LineCapPicker(selection: self.$model.lineCap)
        Picker("Line Width", selection: self.$model.lineWidth) {
          Text("Default").tag(Optional<CGFloat>.none)
          Text("2").tag(Optional<CGFloat>.some(2))
          Text("4").tag(Optional<CGFloat>.some(4))
          Text("8").tag(Optional<CGFloat>.some(8))
        }
        Picker("Shape", selection: self.$model.shape) {
          Text("Circle").tag(CircularProgressVM.Shape.circle)
          Text("Arc").tag(CircularProgressVM.Shape.arc)
        }
        OptionalSizePicker(selection: self.$model.size)
      }
      .onReceive(self.timer) { _ in
        if self.model.currentValue < self.model.maxValue {
          let step = (self.model.maxValue - self.model.minValue) / 100
          self.model.currentValue = min(
            self.model.maxValue,
            self.model.currentValue + CGFloat(Int.random(in: 1...20)) * step
          )
        } else {
          self.model.currentValue = self.model.minValue
        }
        self.model.label = "\(Int(self.model.currentValue))%"
      }
    }
  }
  
  // MARK: - Helpers
  
  private static var initialModel = CircularProgressVM {
    $0.label = "0%"
    $0.currentValue = 0.0
  }
}

#Preview {
  CircularProgressPreview()
}
