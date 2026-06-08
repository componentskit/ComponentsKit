# ComponentsKit Agent Guide

## Project Overview

ComponentsKit is a Swift Package for iOS 15+ that provides reusable UIKit and SwiftUI components for building app interfaces faster. The package product is `ComponentsKit`, implemented in `Sources/ComponentsKit`, with an example demos app under `Examples/DemosApp`.

The library uses a consistent component model:

- `*VM` structs define configurable appearance, state, and content.
- `SU*` types are SwiftUI views.
- `UK*` types are UIKit views or view controllers.
- UIKit components usually conform to `UKComponent` and update when their `model` changes.
- Shared styling comes from `Theme.current`, `Palette`, `Layout`, `ComponentColor`, `UniversalColor`, `UniversalImage`, and common size/style enums in `Sources/ComponentsKit/Shared`.

## Repository Layout

- `Package.swift`: Swift Package manifest for the `ComponentsKit` library.
- `Sources/ComponentsKit/Components`: Component implementations.
- `Sources/ComponentsKit/Shared`: Shared protocols, colors, images, fonts, and reusable value types.
- `Sources/ComponentsKit/Theme`: Global theme, palette, and layout definitions.
- `Sources/ComponentsKit/Helpers`: UIKit, SwiftUI, and Swift helpers.
- `Sources/ComponentsKit/Resources`: Package resources and privacy manifest.
- `Examples/DemosApp`: iOS demo app with previews for each component.

## Components

| Component | SwiftUI | UIKit | Main interaction |
| --- | --- | --- | --- |
| Alert | `SUAlert` | `UKAlertController` | Configure `AlertVM` and `AlertButtonVM`; present as an alert surface. |
| Avatar | `SUAvatar` | `UKAvatar` | Configure `AvatarVM` with image, placeholder, size, and style. |
| Avatar Group | `SUAvatarGroup` | `UKAvatarGroup` | Configure `AvatarGroupVM` with `AvatarItemVM` items. |
| Badge | `SUBadge` | `UKBadge` | Configure `BadgeVM` with title, color, size, and style. |
| Button | `SUButton` | `UKButton` | Configure `ButtonVM`; pass an action closure for taps. |
| Card | `SUCard` | `UKCard` | Configure `CardVM`; place content inside the card surface. |
| Checkbox | `SUCheckbox` | `UKCheckbox` | Configure `CheckboxVM`; bind or update checked state from user selection. |
| Circular Progress | `SUCircularProgress` | `UKCircularProgress` | Configure `CircularProgressVM` with progress, style, and size. |
| Countdown | `SUCountdown` | `UKCountdown` | Configure `CountdownVM`; use `CountdownManager` for countdown updates. |
| Divider | `SUDivider` | `UKDivider` | Configure `DividerVM` with orientation and styling. |
| Input Field | `SUInputField` | `UKInputField` | Configure `InputFieldVM` for single-line input and title/helper text behavior. |
| Loading | `SULoading` | `UKLoading` | Configure `LoadingVM` with size and color. |
| Bottom Modal | `SUBottomModal` | `UKBottomModalController` | Configure `BottomModalVM`; present bottom-sheet content. |
| Center Modal | `SUCenterModal` | `UKCenterModalController` | Configure `CenterModalVM`; present centered modal content. |
| Progress Bar | `SUProgressBar` | `UKProgressBar` | Configure `ProgressBarVM` with progress, size, and style. |
| Radio Group | `SURadioGroup` | `UKRadioGroup` | Configure `RadioGroupVM` with `RadioItemVM` items and selected value. |
| Segmented Control | `SUSegmentedControl` | `UKSegmentedControl` | Configure `SegmentedControlVM` with `SegmentedControlItemVM` items and selection. |
| Slider | `SUSlider` | `UKSlider` | Configure `SliderVM` with value, range, step, and style. |
| Text Input | `SUTextInput` | `UKTextInput` | Configure `TextInputVM` for multi-line text entry. |

## How to Use Components

Import the package and create a view model for the component you need:

```swift
import ComponentsKit

let model = ButtonVM {
  $0.title = "Continue"
  $0.style = .filled
  $0.size = .large
}
```

In SwiftUI, pass the model into the matching `SU*` view:

```swift
SUButton(model: model) {
  // Handle tap.
}
```

In UIKit, instantiate the matching `UK*` view or controller and update its `model` when state changes:

```swift
let button = UKButton(model: model) {
  // Handle tap.
}

button.model = ButtonVM {
  $0.title = "Loading"
  $0.isLoading = true
}
```

Use `Theme.current` to customize global colors and layout. Components that observe theme changes will restyle themselves when the theme changes.

## Working Guidelines

- Follow the existing component pattern: model in `Models`, SwiftUI surface as `SU*`, UIKit surface as `UK*`, and shared helpers only when needed.
- Keep public APIs documented with concise doc comments.
- Prefer existing shared types for sizes, colors, radii, shadows, paddings, images, and fonts.
- Add or update the matching demo preview in `Examples/DemosApp/DemosApp/ComponentsPreview/PreviewPages` when changing component behavior.
- Build with Swift Package Manager or the Xcode workspace before handing off substantial changes.
