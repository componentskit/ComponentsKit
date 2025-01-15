import ComponentsKit
import SwiftUI

struct App: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLinkWithTitle("Alert") {
          AlertPreview()
        }
        NavigationLinkWithTitle("Badge") {
          BadgePreview()
        }
        NavigationLinkWithTitle("Button") {
          ButtonPreview()
        }
        NavigationLinkWithTitle("Card") {
          CardPreview()
        }
        NavigationLinkWithTitle("Checkbox") {
          CheckboxPreview()
        }
        NavigationLinkWithTitle("Countdown") {
          CountdownPreview()
        }
        NavigationLinkWithTitle("Divider") {
          DividerPreview()
        }
        NavigationLinkWithTitle("Input Field") {
          InputFieldPreview()
        }
        NavigationLinkWithTitle("Loading") {
          LoadingPreview()
        }
        NavigationLinkWithTitle("Progress Bar") {
          ProgressBarPreview()
        }
        NavigationLinkWithTitle("Modal (Bottom)") {
          BottomModalPreview()
        }
        NavigationLinkWithTitle("Modal (Center)") {
          CenterModalPreview()
        }
        NavigationLinkWithTitle("Radio Group") {
          RadioGroupPreview()
        }
        NavigationLinkWithTitle("Segmented Control") {
          SegmentedControlPreview()
        }
        NavigationLinkWithTitle("Text Input") {
          TextInputPreviewPreview()
        }
      }
      .navigationTitle("Components")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

// MARK: - Helper

private struct NavigationLinkWithTitle<Destination: View>: View {
  let title: String
  @ViewBuilder let destination: () -> Destination

  init(_ title: String, destination: @escaping () -> Destination) {
    self.title = title
    self.destination = destination
  }

  var body: some View {
    NavigationLink(self.title) {
      self.destination()
        .navigationTitle(self.title)
    }
  }
}

// MARK: - Preview

#Preview {
  App()
}
