import SwiftUI

public struct SwiftBlocksCraftPanel: View {
    @Environment(\.edkTheme) private var theme

    @State private var request: EDKCraftRequest
    @State private var craftedBlocks: [EDKCraftedBlock]

    private let engine: EDKLocalAutoCraftEngine

    public init(
        initialRequest: EDKCraftRequest = EDKCraftRequest(),
        engine: EDKLocalAutoCraftEngine = EDKLocalAutoCraftEngine()
    ) {
        self.engine = engine
        self._request = State(initialValue: initialRequest)
        self._craftedBlocks = State(initialValue: engine.craft(initialRequest))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            header
            promptField
            intentPicker
            variantPicker
            radiusControl
            craftButton
            craftedResults
            Spacer(minLength: 0)
        }
        .padding(theme.spacing.md)
        .frame(minWidth: 280, idealWidth: 320, maxWidth: 360)
        .background(.regularMaterial)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("Auto Craft", systemImage: "sparkles")
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text("Create two local block suggestions.")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }

    private var promptField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Prompt")
                .font(.caption.weight(.semibold))
            TextField("Login header, pricing card, CTA...", text: $request.prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)
        }
    }

    private var intentPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Block")
                .font(.caption.weight(.semibold))
            Picker("Block", selection: $request.intent) {
                ForEach(EDKCraftIntent.allCases) { intent in
                    Text(intent.title).tag(intent)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var variantPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color")
                .font(.caption.weight(.semibold))
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 34), spacing: 8)], spacing: 8) {
                ForEach(EDKVariant.allCases) { variant in
                    Button {
                        request.variant = variant
                    } label: {
                        Circle()
                            .fill(swatchColor(for: variant))
                            .frame(width: 24, height: 24)
                            .overlay {
                                Circle()
                                    .stroke(request.variant == variant ? theme.colors.dark : theme.colors.stroke, lineWidth: request.variant == variant ? 3 : 1)
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(variant.rawValue.capitalized)
                }
            }
        }
    }

    private var radiusControl: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Radius")
                    .font(.caption.weight(.semibold))
                Spacer()
                Text("\(Int(request.cornerRadius))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Slider(value: $request.cornerRadius, in: 0...28, step: 1)
        }
    }

    private var craftButton: some View {
        Button {
            withAnimation(.snappy(duration: 0.22)) {
                craftedBlocks = engine.craft(request)
            }
        } label: {
            Label("Craft", systemImage: "wand.and.sparkles")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(EDKButtonStyle(style: EDKComponentStyle(variant: request.variant, size: .medium, cornerRadius: request.cornerRadius)))
    }

    private var craftedResults: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            Text("Results")
                .font(.caption.weight(.semibold))
                .padding(.top, theme.spacing.xs)

            ForEach(craftedBlocks) { block in
                EDKCraftedBlockCard(block: block)
                    .draggable(block)
            }
        }
    }

    private func swatchColor(for variant: EDKVariant) -> Color {
        variant == .glass ? theme.colors.light : variant.background(in: theme)
    }
}

private struct EDKCraftedBlockCard: View {
    @Environment(\.edkTheme) private var theme

    let block: EDKCraftedBlock

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            HStack(spacing: theme.spacing.xs) {
                Image(systemName: "square.stack.3d.up")
                    .foregroundStyle(theme.colors.primary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(block.title)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                    Text(block.summary)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
            }

            HStack(spacing: 5) {
                ForEach(block.nodes.prefix(4)) { node in
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(node.style.variant == .glass ? theme.colors.stroke.opacity(0.5) : node.style.variant.background(in: theme))
                        .frame(width: max(18, min(48, node.frame.width / 5)), height: 8)
                }
            }
        }
        .padding(theme.spacing.sm)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(theme.colors.stroke, lineWidth: 1)
        }
        .accessibilityLabel("Crafted block \(block.title)")
    }

}

public struct SwiftBlocksStudio: View {
    @State private var store: EDKDesignCanvasStore

    public init(store: EDKDesignCanvasStore = EDKDesignCanvasStore.sample()) {
        self._store = State(initialValue: store)
    }

    public var body: some View {
        ViewThatFits {
            HStack(spacing: 0) {
                SwiftBlocksCraftPanel()
                Divider()
                EDKDesignCanvas(store: store)
            }

            VStack(spacing: 0) {
                SwiftBlocksCraftPanel()
                    .frame(maxHeight: 360)
                Divider()
                EDKDesignCanvas(store: store)
            }
        }
    }
}

public struct SwiftBlocksCraftWindow: View {
    public init() {}

    public var body: some View {
        SwiftBlocksStudio()
            .frame(minWidth: 980, minHeight: 680)
    }
}

#Preview("SwiftBlocks Auto Craft") {
    SwiftBlocksCraftWindow()
}
