# Architecture

SwiftBlocks is split into three layers.

## Theme

`EDKTheme` contains semantic colors, spacing, radius, and typography scales. The default palette follows Bootstrap-style intent names such as `primary`, `success`, `warning`, and `danger`.

## Components

`EDKButton` and `EDKSurface` are the first production-facing blocks. They read from the SwiftUI environment and support semantic variants, size scales, and iOS 26 Liquid Glass where available.

## Canvas

`EDKDesignCanvas` is the visual builder. It uses:

- `EDKPaletteItem` for draggable palette entries
- `EDKDesignCanvasStore` for observable editor state
- `EDKDesignDocument` for Codable layout persistence
- `EDKDesignNode` for individual blocks

The document model is intentionally separate from SwiftUI views so future code generation, import/export, and persistence can evolve without rewriting the UI.
