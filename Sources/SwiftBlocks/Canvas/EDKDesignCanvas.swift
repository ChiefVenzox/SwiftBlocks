import SwiftUI

public struct EDKDesignCanvas: View {
    @Environment(\.edkTheme) private var theme
    @State private var store: EDKDesignCanvasStore

    private let palette: [EDKPaletteItem]

    public init(
        store: EDKDesignCanvasStore = EDKDesignCanvasStore.sample(),
        palette: [EDKPaletteItem] = EDKPaletteItem.basic
    ) {
        self._store = State(initialValue: store)
        self.palette = palette
    }

    public var body: some View {
        GeometryReader { proxy in
            if proxy.size.width < 640 {
                compactBody
            } else {
                regularBody
            }
        }
        .background(theme.colors.canvas)
    }

    private var regularBody: some View {
        ViewThatFits {
            HStack(spacing: 0) {
                EDKComponentPalette(items: palette)
                    .frame(width: 180)
                Divider()
                editorBody
            }

            VStack(spacing: 0) {
                EDKComponentPalette(items: palette)
                    .frame(height: 96)
                Divider()
                editorBody
            }
        }
    }

    private var compactBody: some View {
        VStack(spacing: 0) {
            EDKCompactComponentPalette(items: palette)
                .frame(height: 72)
            Divider()
            canvasBody
        }
    }

    private var editorBody: some View {
        HStack(spacing: 0) {
            canvasBody
            Divider()
            EDKCanvasInspector(store: store)
                .frame(width: 210)
        }
    }

    private var canvasBody: some View {
        GeometryReader { proxy in
            let scale = min(
                proxy.size.width / store.document.canvasWidth,
                proxy.size.height / store.document.canvasHeight
            )

            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
                    .overlay(alignment: .topLeading) {
                        EDKCanvasGrid()
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    }
                    .frame(width: store.document.canvasWidth, height: store.document.canvasHeight)
                    .scaleEffect(scale, anchor: .center)

                ZStack(alignment: .topLeading) {
                    ForEach(store.document.nodes) { node in
                        EDKCanvasNodeView(
                            node: node,
                            isSelected: node.id == store.selectedNodeID,
                            canvasSize: store.document.canvasSize,
                            onSelect: { store.select(node.id) },
                            onFrameChange: { store.updateFrame(id: node.id, frame: $0) }
                        )
                    }
                }
                .frame(width: store.document.canvasWidth, height: store.document.canvasHeight)
                .scaleEffect(scale, anchor: .center)
                .dropDestination(for: EDKPaletteItem.self) { items, location in
                    guard let item = items.first else { return false }
                    let canvasPoint = canvasPoint(from: location, in: proxy.size, scale: scale)
                    store.add(item, at: canvasPoint)
                    return true
                }
                .dropDestination(for: EDKCraftedBlock.self) { blocks, location in
                    guard let block = blocks.first else { return false }
                    let canvasPoint = canvasPoint(from: location, in: proxy.size, scale: scale)
                    store.add(block, at: canvasPoint)
                    return true
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                store.select(nil)
            }
        }
    }

    private func canvasPoint(from location: CGPoint, in containerSize: CGSize, scale: Double) -> CGPoint {
        let canvasOrigin = CGPoint(
            x: (containerSize.width - store.document.canvasWidth * scale) / 2,
            y: (containerSize.height - store.document.canvasHeight * scale) / 2
        )
        return CGPoint(
            x: (location.x - canvasOrigin.x) / scale,
            y: (location.y - canvasOrigin.y) / scale
        )
    }
}

public struct EDKCompactComponentPalette: View {
    @Environment(\.edkTheme) private var theme

    private let items: [EDKPaletteItem]

    public init(items: [EDKPaletteItem] = EDKPaletteItem.basic) {
        self.items = items
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.spacing.xs) {
                ForEach(items) { item in
                    VStack(spacing: 5) {
                        Image(systemName: item.kind.symbolName)
                            .font(.system(size: 15, weight: .semibold))
                        Text(item.kind.paletteTitle)
                            .font(.system(size: 10, weight: .semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                    }
                    .foregroundStyle(item.variant.foreground(in: theme))
                    .frame(width: 72, height: 52)
                    .edkSurfaceBackground(
                        variant: item.variant,
                        cornerRadius: theme.radii.sm,
                        isInteractive: true,
                        theme: theme
                    )
                    .draggable(item)
                    .accessibilityLabel("Add \(item.kind.paletteTitle)")
                    .accessibilityHint("Drag to canvas to place component")
                }
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
        }
        .background(.regularMaterial)
    }
}

public struct EDKComponentPalette: View {
    @Environment(\.edkTheme) private var theme

    private let items: [EDKPaletteItem]

    public init(items: [EDKPaletteItem] = EDKPaletteItem.basic) {
        self.items = items
    }

    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: theme.spacing.xs) {
                ForEach(items) { item in
                    HStack(spacing: theme.spacing.xs) {
                        Image(systemName: item.kind.symbolName)
                            .frame(width: 26)
                        Text(item.kind.paletteTitle)
                            .font(.system(size: 13, weight: .semibold))
                        Spacer(minLength: 0)
                    }
                    .foregroundStyle(item.variant.foreground(in: theme))
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.vertical, theme.spacing.xs)
                    .edkSurfaceBackground(
                        variant: item.variant,
                        cornerRadius: theme.radii.sm,
                        isInteractive: true,
                        theme: theme
                    )
                    .draggable(item)
                    .accessibilityLabel("Add \(item.kind.paletteTitle)")
                    .accessibilityHint("Drag to canvas to place component")
                }
            }
            .padding(theme.spacing.sm)
        }
        .background(.regularMaterial)
    }
}

private struct EDKCanvasNodeView: View {
    @Environment(\.edkTheme) private var theme

    let node: EDKDesignNode
    let isSelected: Bool
    let canvasSize: CGSize
    let onSelect: () -> Void
    let onFrameChange: (EDKDesignFrame) -> Void

    @State private var moveStartFrame: EDKDesignFrame?
    @State private var resizeStartFrame: EDKDesignFrame?

    var body: some View {
        renderedNode
            .frame(width: node.frame.width, height: node.frame.height)
            .overlay {
                RoundedRectangle(cornerRadius: max(8, CGFloat(node.style.cornerRadius)), style: .continuous)
                    .stroke(isSelected ? theme.colors.primary : .clear, lineWidth: 2)
            }
            .overlay(alignment: .bottomTrailing) {
                if isSelected {
                    resizeHandle
                        .offset(x: 8, y: 8)
                }
            }
            .offset(x: node.frame.x, y: node.frame.y)
            .contentShape(Rectangle())
            .onTapGesture(perform: onSelect)
            .gesture(moveGesture)
    }

    @ViewBuilder
    private var renderedNode: some View {
        switch node.kind {
        case .button:
            EDKButton(node.content.title, style: node.style) {}
                .disabled(true)
        case .text:
            Text(node.content.title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(node.style.variant.background(in: theme))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, theme.spacing.sm)
        case .card:
            EDKSurface(style: node.style) {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(node.content.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Text(node.content.subtitle.isEmpty ? "Drop components nearby and resize live." : node.content.subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        case .hStack:
            HStack(spacing: theme.spacing.xs) {
                previewChip("A")
                previewChip("B")
                previewChip("C")
            }
            .padding(theme.spacing.sm)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.colors.light, in: RoundedRectangle(cornerRadius: CGFloat(node.style.cornerRadius), style: .continuous))
        case .vStack:
            VStack(spacing: theme.spacing.xs) {
                previewChip("One")
                previewChip("Two")
            }
            .padding(theme.spacing.sm)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.colors.light, in: RoundedRectangle(cornerRadius: CGFloat(node.style.cornerRadius), style: .continuous))
        case .spacer:
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(theme.colors.stroke.opacity(0.7))
                .overlay {
                    Text("Spacer")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(theme.colors.secondary)
                }
        }
    }

    private func previewChip(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, minHeight: 28)
            .background(.white, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(theme.colors.stroke, lineWidth: 1)
            }
    }

    private var resizeHandle: some View {
        Image(systemName: "arrow.down.right.and.arrow.up.left")
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 22, height: 22)
            .background(theme.colors.primary, in: Circle())
            .shadow(color: .black.opacity(0.14), radius: 6, y: 2)
            .highPriorityGesture(resizeGesture)
            .accessibilityLabel("Resize")
    }

    private var moveGesture: some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { value in
                if moveStartFrame == nil {
                    moveStartFrame = node.frame
                    onSelect()
                }
                guard let moveStartFrame else { return }
                let nextFrame = moveStartFrame
                    .movedBy(x: Double(value.translation.width), y: Double(value.translation.height))
                    .clamped(to: canvasSize)
                onFrameChange(nextFrame)
            }
            .onEnded { _ in
                moveStartFrame = nil
            }
    }

    private var resizeGesture: some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { value in
                if resizeStartFrame == nil {
                    resizeStartFrame = node.frame
                    onSelect()
                }
                guard let resizeStartFrame else { return }
                let nextFrame = resizeStartFrame
                    .resizedBy(
                        width: Double(value.translation.width),
                        height: Double(value.translation.height),
                        minimumSize: CGSize(width: 44, height: 32)
                    )
                    .clamped(to: canvasSize)
                onFrameChange(nextFrame)
            }
            .onEnded { _ in
                resizeStartFrame = nil
            }
    }
}

private struct EDKCanvasInspector: View {
    @Bindable var store: EDKDesignCanvasStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Inspector")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            if let selectedNode = store.selectedNode {
                Text(selectedNode.kind.paletteTitle)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text("Variant")
                    .font(.caption.weight(.semibold))
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 78), spacing: 8)], spacing: 8) {
                    ForEach(EDKVariant.allCases) { variant in
                        Button(variant.rawValue.capitalized) {
                            store.updateStyle(id: selectedNode.id) { style in
                                style.variant = variant
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }

                Text("Size")
                    .font(.caption.weight(.semibold))
                Picker("Size", selection: sizeBinding(for: selectedNode)) {
                    ForEach(EDKComponentSize.allCases) { size in
                        Text(size.rawValue.capitalized).tag(size)
                    }
                }
                .pickerStyle(.segmented)

                Button(role: .destructive) {
                    store.removeSelectedNode()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 24))
                        .foregroundStyle(theme.colors.stroke)
                    Text("Select a component")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(.regularMaterial)
    }

    private func sizeBinding(for node: EDKDesignNode) -> Binding<EDKComponentSize> {
        Binding(
            get: { store.selectedNode?.style.size ?? node.style.size },
            set: { newValue in
                store.updateStyle(id: node.id) { style in
                    style.size = newValue
                }
            }
        )
    }
}

private struct EDKCanvasGrid: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 16
            var path = Path()

            stride(from: CGFloat(0), through: size.width, by: step).forEach { x in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }

            stride(from: CGFloat(0), through: size.height, by: step).forEach { y in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }

            context.stroke(path, with: .color(.gray.opacity(0.12)), lineWidth: 0.5)
        }
    }
}

private extension EDKComponentKind {
    var symbolName: String {
        switch self {
        case .button: "rectangle.and.hand.point.up.left"
        case .text: "textformat"
        case .card: "rectangle.stack"
        case .hStack: "rectangle.split.3x1"
        case .vStack: "rectangle.split.1x2"
        case .spacer: "arrow.left.and.right"
        }
    }

    var paletteTitle: String {
        switch self {
        case .button: "Button"
        case .text: "Text"
        case .card: "Surface"
        case .hStack: "HStack"
        case .vStack: "VStack"
        case .spacer: "Spacer"
        }
    }
}

#Preview("SwiftBlocks Canvas") {
    EDKDesignCanvas()
        .frame(minWidth: 900, minHeight: 680)
}
