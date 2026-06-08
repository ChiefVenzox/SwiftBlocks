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

## Open the Workspace

```swift
#Preview {
    SwiftBlocksWorkspaceView()
}
```

The workspace includes Blocks, Canvas, Inspector, Tokens, Templates, Craft, and Export tabs. It opens on Craft by default, so you can generate native SwiftUI component code from prompts, component types, and styles, then press **Add to Canvas**.

## Open the live canvas directly

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

Use the craft panel to choose a block type, color, and radius. Press **Craft** to create two suggestions, then drag either suggestion onto the canvas.

Craft is fully local and deterministic. It uses Swift presets and templates only, so there is no API key, no server, and no internet requirement.

## Use the Xcode Library

After adding SwiftBlocks as a package dependency, open Xcode's Library with the `+` button and search for `SwiftBlocks`.

Available library items:

- SwiftBlocks Workspace
- SwiftBlocks Button
- SwiftBlocks Glass Card
- SwiftBlocks Canvas
- SwiftBlocks Auto Craft

Drag `SwiftBlocks Workspace` into code or the SwiftUI preview canvas for the full builder. Use the other items for focused component examples.

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
