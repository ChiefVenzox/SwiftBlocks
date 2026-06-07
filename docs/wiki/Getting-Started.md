# Getting Started

## Install

In Xcode, choose **File > Add Package Dependencies...** and use:

```text
https://github.com/ChiefVenzox/SwiftBlocks.git
```

Then import the package:

```swift
import SwiftUI
import SwiftBlocks
```

## Open the live canvas

```swift
#Preview {
    EDKDesignCanvas()
}
```

The canvas includes a palette, an iPhone-sized design surface, and an inspector. Drag blocks from the palette, tap to select, drag to move, and use the resize handle to change dimensions.

## Open Auto Craft

```swift
#Preview {
    SwiftBlocksCraftWindow()
}
```

Use the craft panel to choose a block type, color, and radius. Press **Craft** to create two local suggestions, then drag either suggestion onto the canvas.

## Use components directly

```swift
EDKButton("Continue", style: EDKComponentStyle(variant: .primary)) {
    print("Continue")
}
```

```swift
EDKSurface(style: EDKComponentStyle(variant: .glass, cornerRadius: 14)) {
    Text("Liquid Glass surface")
}
```
