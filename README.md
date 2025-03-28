<p align="center">
  <a href="https://componentskit.io" target="_blank">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/componentskit/ComponentsKit/HEAD/.github/logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/componentskit/ComponentsKit/HEAD/.github/logo-light.svg">
      <img alt="ComponentsKit" src="https://raw.githubusercontent.com/componentskit/ComponentsKit/HEAD/.github/logo-light.svg" width="350" height="70" style="max-width: 100%;">
    </picture>
  </a>
</p>

<p align="center">
  A library with beautiful UI components to build SwiftUI and UIKit apps faster.
</p>

---

## Installation

Add ComponentsKit to an Xcode project as a package dependency:

1. From the **File** menu, select **Add Package Dependencies...**.
2. Enter `https://github.com/componentskit/ComponentsKit` into the package repository URL text field.
3. Add **componentskit** to your application.

## Basic Usage

### Components

All components in the library have `view models` that should be used to configure their *appearance*. These models are shared between **SwiftUI** and **UIKit** components. For example, an input field can be configured as follows:

```swift
let inputFieldVM = InputFieldVM {
  $0.title = "Email"
  $0.placeholder = "Enter your email"
  $0.isRequired = true
}
```

> [!Note] 
> All `view models` in **ComponentsKit** do not have memberwise initializers. Instead, they conform to the `ComponentVM` protocol, which defines an initializer that modifies default values:
> ```swift
> /// Initializes a new instance by applying a transformation closure to the default values.
> ///
> /// - Parameter transform: A closure that defines the transformation.
> init(_ transform: (_ value: inout Self) -> Void)
> ```
> This approach has two main benefits:
> 1. It allows you to set parameters in any order, making the initializers easier to use.
> 2. Future changes can be made without breaking your code, as it simplifies deprecation.

To control the *behavior* in **SwiftUI**, you should use bindings:

```swift
@State var email: String
@FocusState var isEmailFieldFocused: Bool

SUInputField(
  text: $email,
  isFocused: $isEmailFieldFocused,
  model: inputFieldVM
)

// Track changes in the inputted text
.onChange(of: self.email) { oldValue, newValue in
  ...
}

// Control the focus (e.g., hide the keyboard)
isEmailFieldFocused = false
```

To control the behavior in **UIKit**, you should use the components' public variables:

```swift
let inputField = UKInputField(model: inputFieldVM)

// Access the text
var inputtedText = inputField.text

// Assign a new closure to handle text changes
inputField.onValueChange = { newText in
  inputtedText = newText
}

// Control the focus (e.g., hide the keyboard)
inputField.resignFirstResponder()
```

### Styling

**Theme**

The library comes with predefined fonts, sizes and colors, but you can change these values to customize the appearance of your app. To do this, alter the current theme:

```swift
Theme.current.update {
  // Update colors
  $0.colors.primary = ...
  
  // Update layout
  $0.layout.componentRadius.medium = ...
}
```

> [!Note] 
> The best place to set up the initial theme is in the `func application(_:, didFinishLaunchingWithOptions:) -> Bool` method in your `AppDelegate` or a similar method in `SceneDelegate`.

By altering the theme, you can also create *custom themes* for your app. To do this, first create a new instance of a `Theme`:

```swift
let halloweenTheme = Theme {
  $0.colors.background = .themed(
    light: .hex("#e38f36"),
    dark: .hex("#ba5421")
  )
  ...
}
```

When the user switches the theme, apply it by assigning it to the `current` instance: 

```swift
Theme.current = halloweenTheme
```

**Handling Theme Changes**

When changing themes dynamically, you may need to **update the UI** to reflect the new theme. Below are approaches for handling this in different environments.

**SwiftUI**

For SwiftUI apps, you can use `ThemeChangeObserver` to automatically refresh views when the theme updates.

```swift
@main
struct Root: App {
  var body: some Scene {
    WindowGroup {
      ThemeChangeObserver {
        Content()
      }
    }
  }
}
```

We recommend using this helper in the root of your app to redraw everything at once.

**UIKit**

For UIKit apps, use the `observeThemeChange(_:)` method to update elements that depend on the properties from the library.

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    style()

    observeThemeChange { [weak self] in
        guard let self else { return }
        self.style()
    }
}

func style() {
  view.backgroundColor = UniversalColor.background.uiColor
  button.model = ButtonVM {
    $0.title = "Tap me"
    $0.color = .accent
  }
}
```

**Manually Handling Theme Changes**

If you are not using the built-in helpers, you can listen for theme change notifications and manually update the UI:

```swift
NotificationCenter.default.addObserver(
    self,
    selector: #selector(handleThemeChange),
    name: Theme.didChangeThemeNotification,
    object: nil
)

@objc private func handleThemeChange() {
    view.backgroundColor = UniversalColor.background.uiColor
}
```

Don't forget to remove the observer when the view is deallocated:
```swift
deinit {
    NotificationCenter.default.removeObserver(self, name: Theme.didChangeThemeNotification, object: nil)
}
```

**Extend Colors**

All colors from the theme can be used within the app. For example:

```swift
// in UIKit
view.backgroundColor = UniversalColor.background.uiColor

// in SwiftUI
SomeView()
  .background(UniversalColor.background.color)
```

If you want to use additional colors that are not included in the theme, you can extend `UniversalColor`:

```swift
extension UniversalColor {
  static var special: UniversalColor {
    if selectedTheme == .halloween {
      return ...
    } else {
      return ...
    }
  }
}

// Then in your class
let view = UIView()
view.backgroundColor = UniversalColor.special.uiColor
```

**Extend Fonts**

If you want to use additional fonts that are not included in the theme, you can extend `UniversalFont`:

```swift
extension UniversalFont {
  static let title: UniversalFont = .system(size: 16, weight: .regular)
}

// Then in your view
Text("Hello, World")
  .font(UniversalFont.title.font)
```

You can also extend `UniversalFont` for easier access to custom fonts:

```swift
extension UniversalFont {
  static func myFont(ofSize size: CGFloat, weight: Weight) -> UniversalFont {
    switch weight {
    case .regular:
      return ...
    }
  }
}

// Then in your view
Text("Hello, World")
  .font(UniversalFont.myFont(ofSize: 14, weight: .regular).font)
```
