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

## Workspace

`SwiftBlocksWorkspaceView` is the tabbed builder surface for package users. It exposes the complete workspace flow:

- Blocks
- Canvas
- Inspector
- Tokens
- Templates
- Craft
- Export

## Craft

Craft is local component generation for SwiftUI structures. It uses `SwiftBlocksCraftRequest`, `SwiftBlocksCraftComponentType`, `SwiftBlocksCraftStyle`, and `SwiftBlocksCraftGenerator` to produce deterministic `SwiftBlocksCraftResult` values.

The first generator implementation is template-driven. It produces previewable SwiftUI code for common components such as buttons, cards, form rows, hero sections, and settings cells. No API key, server, internet access, or external AI service is required.

Legacy compact craft surfaces still return `EDKCraftedBlock`, so generated blocks can be added to the same canvas document model safely.
