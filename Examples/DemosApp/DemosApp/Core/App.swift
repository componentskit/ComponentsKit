import ComponentsKit
import SwiftUI

struct App: View {
  var body: some View {
    NavigationView {
      List {
        Section("Components") {
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
          NavigationLinkWithTitle("Radio Group") {
            RadioGroupPreview()
          }
          NavigationLinkWithTitle("Segmented Control") {
            SegmentedControlPreview()
          }
          NavigationLinkWithTitle("Text Field") {
            TextInputPreviewPreview()
          }
        }

        Section("Modals") {
          NavigationLinkWithTitle("Bottom Modal") {
            BottomModalPreview()
          }
          NavigationLinkWithTitle("Center Modal") {
            CenterModalPreview()
          }
        }

        Section("Login Demo") {
          NavigationLinkWithTitle("SwiftUI") {
            SwiftUILogin()
          }
          NavigationLinkWithTitle("UIKit") {
            UIViewControllerRepresenting {
              UIKitLogin()
            }
          }
        }
      }
      .navigationTitle("Examples")
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
