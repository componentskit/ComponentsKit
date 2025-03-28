import ComponentsKit
import SwiftUI

struct App: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLinkWithTitle("Alert") {
          AlertPreview()
        }
        NavigationLinkWithTitle("Avatar") {
          AvatarPreview()
        }
        NavigationLinkWithTitle("Avatar Group") {
          AvatarGroupPreview()
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
        NavigationLinkWithTitle("Circular Progress") {
          CircularProgressPreview()
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
        NavigationLinkWithTitle("Modal (Bottom)") {
          BottomModalPreview()
        }
        NavigationLinkWithTitle("Modal (Center)") {
          CenterModalPreview()
        }
        NavigationLinkWithTitle("Progress Bar") {
          ProgressBarPreview()
        }
        NavigationLinkWithTitle("Radio Group") {
          RadioGroupPreview()
        }
        NavigationLinkWithTitle("Segmented Control") {
          SegmentedControlPreview()
        }
        NavigationLinkWithTitle("Slider") {
          SliderPreview()
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
