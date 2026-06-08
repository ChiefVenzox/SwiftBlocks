# SwiftBlocks

SwiftBlocks is a SwiftUI design-system package for building iOS interfaces from composable blocks. It combines Bootstrap-inspired semantic tokens, iOS 26 Liquid Glass-aware surfaces, reusable SwiftUI components, and a live drag-and-drop canvas editor.

The goal is simple: add the package in Xcode, open a SwiftUI preview, drag blocks onto a canvas, resize and style them live, then evolve the document into production SwiftUI.

## What is inside

- `EDKTheme`: color, spacing, radius, and typography tokens.
- `EDKButton` and `EDKSurface`: reusable SwiftUI components.
- `EDKDesignCanvas`: a live editor for dragging, selecting, moving, and resizing components.
- `EDKDesignDocument`: a Codable model for saving generated layout state.
- `SwiftBlocksWorkspaceView`: a native SwiftUI workspace with Blocks, Canvas, Inspector, Tokens, Templates, Craft, and Export tabs.
- iOS 26 Liquid Glass support with sensible material fallbacks for earlier OS versions.

## Package usage

Add this repository in Xcode with **File > Add Package Dependencies...**, then import the module:

```swift
import SwiftUI
import SwiftBlocks

struct BuilderPreview: View {
    var body: some View {
        SwiftBlocksWorkspaceView()
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

1. Open a SwiftUI preview with `SwiftBlocksWorkspaceView()`.
2. Use the **Craft** tab to generate local SwiftUI components.
3. Press **Add to Canvas** or switch to **Blocks** and drag components onto the canvas.
4. Tap a block to select it.
5. Move it by dragging the block.
6. Resize it with the bottom-right handle.
7. Change size and semantic variant from the inspector.

## Workspace Tabs

- **Blocks** - Browse draggable SwiftBlocks components.
- **Canvas** - Place, move, select, and resize blocks.
- **Inspector** - Inspect selected block sizing, style, and content.
- **Tokens** - Review semantic color and design tokens.
- **Templates** - Start from local layout presets.
- **Craft** - Locally generate SwiftUI components from prompts, presets, and styles without external AI APIs.
- **Export** - Prepare native SwiftUI output from workspace documents.

## Local Component Crafting

SwiftBlocks includes a local Craft workspace for generating SwiftUI component structures from prompts, presets, component types, and styles. Craft is designed to feel AI-assisted while staying fully local, deterministic, and dependency-free.

- No API key required.
- No server required.
- No internet required.
- Generated output is native SwiftUI.

Open the full workspace in a SwiftUI preview:

```swift
import SwiftUI
import SwiftBlocks

#Preview {
    SwiftBlocksWorkspaceView()
}
```

Or open the compact craft/canvas experience:

Open the local craft studio in a SwiftUI preview:

```swift
import SwiftUI
import SwiftBlocks

#Preview {
    SwiftBlocksCraftWindow()
}
```

The craft panels let you enter a prompt, choose a component or block type, select a style, preview the generated result, and copy deterministic SwiftUI code. Everything is generated locally from Swift code templates.

## Xcode Library

SwiftBlocks publishes common blocks to Xcode's Library panel.

After adding the package:

1. Open a SwiftUI file.
2. Open the Xcode Library with the `+` button.
3. Search for `SwiftBlocks`.
4. Drag `SwiftBlocks Workspace` into your code or preview canvas for the full builder. You can also use `SwiftBlocks Button`, `SwiftBlocks Glass Card`, `SwiftBlocks Canvas`, or `SwiftBlocks Auto Craft` for focused examples.

This is the closest native Xcode experience available from a Swift package. A package can add items to the Xcode Library, but it cannot install a permanent custom sidebar inside Xcode.

## Wiki

The project wiki content lives in [`docs/wiki`](docs/wiki) so it can be versioned with the package:

- [`Home`](docs/wiki/Home.md)
- [`Getting Started`](docs/wiki/Getting-Started.md)
- [`Architecture`](docs/wiki/Architecture.md)
- [`Roadmap`](docs/wiki/Roadmap.md)

## Direction

The first release focuses on a stable package foundation. The next layer should export generated SwiftUI code from `EDKDesignDocument`, add component variants, and introduce a richer inspector for padding, typography, colors, and layout constraints.
