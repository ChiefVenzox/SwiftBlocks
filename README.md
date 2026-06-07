# SwiftBlocks

SwiftBlocks is a SwiftUI design-system package for building iOS interfaces from composable blocks. It combines Bootstrap-inspired semantic tokens, iOS 26 Liquid Glass-aware surfaces, reusable SwiftUI components, and a live drag-and-drop canvas editor.

The goal is simple: add the package in Xcode, open a SwiftUI preview, drag blocks onto a canvas, resize and style them live, then evolve the document into production SwiftUI.

## What is inside

- `EDKTheme`: color, spacing, radius, and typography tokens.
- `EDKButton` and `EDKSurface`: reusable SwiftUI components.
- `EDKDesignCanvas`: a live editor for dragging, selecting, moving, and resizing components.
- `EDKDesignDocument`: a Codable model for saving generated layout state.
- iOS 26 Liquid Glass support with sensible material fallbacks for earlier OS versions.

## Package usage

Add this repository in Xcode with **File > Add Package Dependencies...**, then import the module:

```swift
import SwiftUI
import SwiftBlocks

struct BuilderPreview: View {
    var body: some View {
        EDKDesignCanvas()
    }
}

#Preview {
    BuilderPreview()
}
```

Package URL:

```text
https://github.com/ChiefVenzox/SwiftBlocks.git
```

Use components directly in an app:

```swift
EDKButton("Continue", style: EDKComponentStyle(variant: .primary)) {
    // action
}

EDKSurface(style: EDKComponentStyle(variant: .glass, cornerRadius: 14)) {
    Text("Live preview surface")
}
```

## Canvas workflow

1. Open a SwiftUI preview with `EDKDesignCanvas()`.
2. Drag components from the palette onto the canvas.
3. Tap a block to select it.
4. Move it by dragging the block.
5. Resize it with the bottom-right handle.
6. Change size and semantic variant from the inspector.

## Auto Craft

Open the local craft studio in a SwiftUI preview:

```swift
import SwiftUI
import SwiftBlocks

#Preview {
    SwiftBlocksCraftWindow()
}
```

The craft panel lets you enter a prompt, choose a block type, set a semantic color, tune corner radius, and press **Craft**. SwiftBlocks creates two local suggestions. Drag either result onto the canvas and place it wherever you want.

The current craft engine is fully local and deterministic so it works without network access or API keys. The API is shaped so an iOS 26/macOS 26 Foundation Models-backed generator can be added behind the same document model later.

## Xcode Library

SwiftBlocks publishes common blocks to Xcode's Library panel.

After adding the package:

1. Open a SwiftUI file.
2. Open the Xcode Library with the `+` button.
3. Search for `SwiftBlocks`.
4. Drag `SwiftBlocks Button`, `SwiftBlocks Glass Card`, `SwiftBlocks Canvas`, `SwiftBlocks Auto Craft`, or `SwiftBlocks Studio` into your code or preview canvas.

This is the closest native Xcode experience available from a Swift package. A package can add items to the Xcode Library, but it cannot install a permanent custom sidebar inside Xcode.

## Wiki

The project wiki content lives in [`docs/wiki`](docs/wiki) so it can be versioned with the package:

- [`Home`](docs/wiki/Home.md)
- [`Getting Started`](docs/wiki/Getting-Started.md)
- [`Architecture`](docs/wiki/Architecture.md)
- [`Roadmap`](docs/wiki/Roadmap.md)

## Direction

The first release focuses on a stable package foundation. The next layer should export generated SwiftUI code from `EDKDesignDocument`, add component variants, and introduce a richer inspector for padding, typography, colors, and layout constraints.
