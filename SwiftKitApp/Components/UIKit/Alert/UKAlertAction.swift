// Copyright © SwiftKit. All rights reserved.

import UIKit

public struct UKAlertAction {
  let title: String
  let style: ((UKButton) -> Void)?
  let action: (() -> Void)?

  public init(
    title: String,
    style: ((UKButton) -> Void)? = nil,
    action: (() -> Void)? = nil
  ) {
    self.title = title
    self.style = style
    self.action = action
  }
}
