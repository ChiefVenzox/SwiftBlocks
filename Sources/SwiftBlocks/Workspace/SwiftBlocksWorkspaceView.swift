import SwiftUI

public enum SwiftBlocksWorkspaceTab: String, CaseIterable, Identifiable {
    case blocks = "Blocks"
    case canvas = "Canvas"
    case inspector = "Inspector"
    case tokens = "Tokens"
    case templates = "Templates"
    case craft = "Craft"
    case export = "Export"

    public var id: String { rawValue }
}

public struct SwiftBlocksWorkspaceView: View {
    @Environment(\.edkTheme) private var theme
    @State private var selectedTab: SwiftBlocksWorkspaceTab
    @State private var store: EDKDesignCanvasStore

    public init(
        selectedTab: SwiftBlocksWorkspaceTab = .blocks,
        store: EDKDesignCanvasStore = EDKDesignCanvasStore.sample()
    ) {
        self._selectedTab = State(initialValue: selectedTab)
        self._store = State(initialValue: store)
    }

    public var body: some View {
        VStack(spacing: 0) {
            tabBar
            Divider()
            content
        }
        .background(theme.colors.canvas)
    }

    private var tabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SwiftBlocksWorkspaceTab.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Text(tab.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedTab == tab ? theme.colors.primary : .clear, in: Capsule())
                            .foregroundStyle(selectedTab == tab ? .white : theme.colors.dark)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(.regularMaterial)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .blocks:
            EDKComponentPalette()
        case .canvas:
            EDKDesignCanvas(store: store)
        case .inspector:
            workspacePanel("Inspector", systemImage: "slider.horizontal.3") {
                Text("Select a canvas block to inspect size, style, and content.")
                    .foregroundStyle(.secondary)
            }
        case .tokens:
            workspacePanel("Tokens", systemImage: "paintpalette") {
                SwiftBlocksTokenPreview()
            }
        case .templates:
            workspacePanel("Templates", systemImage: "square.grid.2x2") {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Starter templates will use the same local document model as the canvas.")
                        .foregroundStyle(.secondary)
                    Label("Onboarding", systemImage: "sparkles.rectangle.stack")
                    Label("Settings", systemImage: "gearshape")
                    Label("Dashboard", systemImage: "chart.bar")
                }
            }
        case .craft:
            SwiftBlocksCraftTabView { block in
                store.add(block, at: CGPoint(x: 180, y: 180))
                selectedTab = .canvas
            }
        case .export:
            workspacePanel("Export", systemImage: "square.and.arrow.up") {
                Text("SwiftUI export will serialize canvas documents into native SwiftUI structures.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func workspacePanel<Content: View>(
        _ title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Label(title, systemImage: systemImage)
                    .font(.title2.weight(.bold))
                content()
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct SwiftBlocksTokenPreview: View {
    @Environment(\.edkTheme) private var theme

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 12)], spacing: 12) {
            token("Primary", theme.colors.primary)
            token("Success", theme.colors.success)
            token("Danger", theme.colors.danger)
            token("Warning", theme.colors.warning)
            token("Info", theme.colors.info)
            token("Dark", theme.colors.dark)
        }
    }

    private func token(_ title: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 34, height: 34)
            Text(title)
                .font(.subheadline.weight(.semibold))
        }
        .padding(10)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview("SwiftBlocks Workspace") {
    SwiftBlocksWorkspaceView(selectedTab: .craft)
}
