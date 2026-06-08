import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct SwiftBlocksCraftRequest: Equatable, Sendable {
    public var prompt: String
    public var componentType: SwiftBlocksCraftComponentType
    public var style: SwiftBlocksCraftStyle

    public init(
        prompt: String = "",
        componentType: SwiftBlocksCraftComponentType = .button,
        style: SwiftBlocksCraftStyle = .minimal
    ) {
        self.prompt = prompt
        self.componentType = componentType
        self.style = style
    }
}

public enum SwiftBlocksCraftComponentType: String, CaseIterable, Identifiable, Sendable {
    case button = "Button"
    case card = "Card"
    case formRow = "Form Row"
    case heroSection = "Hero Section"
    case profileHeader = "Profile Header"
    case pricingCard = "Pricing Card"
    case settingsCell = "Settings Cell"
    case emptyState = "Empty State"
    case customBlock = "Custom Block"

    public var id: String { rawValue }
}

public enum SwiftBlocksCraftStyle: String, CaseIterable, Identifiable, Sendable {
    case minimal = "Minimal"
    case glass = "Glass"
    case rounded = "Rounded"
    case gradient = "Gradient"
    case outline = "Outline"
    case dashboard = "Dashboard"
    case iOSSettings = "iOS Settings"

    public var id: String { rawValue }
}

public struct SwiftBlocksCraftResult: Equatable, Sendable {
    public var title: String
    public var description: String
    public var swiftUICode: String

    public init(title: String, description: String, swiftUICode: String) {
        self.title = title
        self.description = description
        self.swiftUICode = swiftUICode
    }
}

public struct SwiftBlocksCraftGenerator: Sendable {
    public static func generate(from request: SwiftBlocksCraftRequest) -> SwiftBlocksCraftResult {
        switch request.componentType {
        case .button:
            buttonResult(request)
        case .card:
            cardResult(request)
        case .formRow:
            formRowResult(request)
        case .heroSection:
            heroSectionResult(request)
        case .settingsCell:
            settingsCellResult(request)
        case .profileHeader, .pricingCard, .emptyState, .customBlock:
            customBlockResult(request)
        }
    }

    public static func craftedBlock(from request: SwiftBlocksCraftRequest) -> EDKCraftedBlock {
        let variant = request.style.defaultVariant
        let radius = request.style.defaultRadius
        let title = generate(from: request).title

        switch request.componentType {
        case .button:
            return EDKCraftedBlock(
                title: title,
                summary: "Generated local button block",
                width: 180,
                height: 52,
                nodes: [
                    node(.button, x: 0, y: 0, width: 180, height: 52, title: title, variant: variant, radius: radius),
                ]
            )
        case .card, .pricingCard:
            return EDKCraftedBlock(
                title: title,
                summary: "Generated local card block",
                width: 292,
                height: 158,
                nodes: [
                    node(.card, x: 0, y: 0, width: 292, height: 112, title: title, subtitle: "Locally generated SwiftUI structure.", variant: request.style.cardVariant, radius: radius),
                    node(.button, x: 18, y: 122, width: 128, height: 36, title: "Continue", variant: variant, radius: radius),
                ]
            )
        case .formRow, .settingsCell:
            return EDKCraftedBlock(
                title: title,
                summary: "Generated local row block",
                width: 320,
                height: 62,
                nodes: [
                    node(.card, x: 0, y: 0, width: 320, height: 62, title: title, subtitle: "Tap to configure", variant: request.style.cardVariant, radius: radius),
                ]
            )
        case .heroSection, .profileHeader, .emptyState, .customBlock:
            return EDKCraftedBlock(
                title: title,
                summary: "Generated local composed block",
                width: 320,
                height: 190,
                nodes: [
                    node(.text, x: 0, y: 0, width: 280, height: 44, title: title, variant: variant, radius: radius),
                    node(.card, x: 0, y: 54, width: 320, height: 86, title: "SwiftBlocks", subtitle: "Preset-driven component generation.", variant: request.style.cardVariant, radius: radius),
                    node(.button, x: 0, y: 152, width: 142, height: 38, title: "Add", variant: variant, radius: radius),
                ]
            )
        }
    }

    private static func buttonResult(_ request: SwiftBlocksCraftRequest) -> SwiftBlocksCraftResult {
        SwiftBlocksCraftResult(
            title: promptTitle(request, fallback: "\(request.style.rawValue) Button"),
            description: "A native SwiftUI button generated from local presets.",
            swiftUICode: """
            Button {
                // action
            } label: {
                Label("\(promptTitle(request, fallback: "Continue"))", systemImage: "arrow.right")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            \(styleSnippet(request.style))
            """
        )
    }

    private static func cardResult(_ request: SwiftBlocksCraftRequest) -> SwiftBlocksCraftResult {
        SwiftBlocksCraftResult(
            title: promptTitle(request, fallback: "\(request.style.rawValue) Card"),
            description: "A reusable card surface with title, copy, and action.",
            swiftUICode: """
            VStack(alignment: .leading, spacing: 12) {
                Text("\(promptTitle(request, fallback: "Card Title"))")
                    .font(.title3.weight(.bold))

                Text("Generated locally with SwiftBlocks presets.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button("Continue") {
                    // action
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(20)
            \(styleSnippet(request.style))
            """
        )
    }

    private static func formRowResult(_ request: SwiftBlocksCraftRequest) -> SwiftBlocksCraftResult {
        SwiftBlocksCraftResult(
            title: promptTitle(request, fallback: "Form Row"),
            description: "A compact labeled form row with trailing input area.",
            swiftUICode: """
            HStack(spacing: 12) {
                Text("\(promptTitle(request, fallback: "Email"))")
                    .font(.subheadline.weight(.semibold))

                Spacer()

                Text("Value")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            \(styleSnippet(request.style))
            """
        )
    }

    private static func heroSectionResult(_ request: SwiftBlocksCraftRequest) -> SwiftBlocksCraftResult {
        SwiftBlocksCraftResult(
            title: promptTitle(request, fallback: "Hero Section"),
            description: "A title-led section with supporting copy and primary action.",
            swiftUICode: """
            VStack(alignment: .leading, spacing: 16) {
                Text("\(promptTitle(request, fallback: "Build with SwiftBlocks"))")
                    .font(.largeTitle.weight(.bold))

                Text("Generate native SwiftUI structures locally from presets.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Button("Get Started") {
                    // action
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
            \(styleSnippet(request.style))
            """
        )
    }

    private static func settingsCellResult(_ request: SwiftBlocksCraftRequest) -> SwiftBlocksCraftResult {
        SwiftBlocksCraftResult(
            title: promptTitle(request, fallback: "Settings Cell"),
            description: "An iOS-style settings row with icon, label, and chevron.",
            swiftUICode: """
            HStack(spacing: 12) {
                Image(systemName: "slider.horizontal.3")
                    .frame(width: 30, height: 30)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 7))
                    .foregroundStyle(.white)

                Text("\(promptTitle(request, fallback: "Settings"))")

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            \(styleSnippet(request.style))
            """
        )
    }

    private static func customBlockResult(_ request: SwiftBlocksCraftRequest) -> SwiftBlocksCraftResult {
        SwiftBlocksCraftResult(
            title: promptTitle(request, fallback: request.componentType.rawValue),
            description: "A generic local component block for the selected preset.",
            swiftUICode: """
            VStack(alignment: .leading, spacing: 12) {
                Text("\(promptTitle(request, fallback: request.componentType.rawValue))")
                    .font(.headline)

                Text("Customize this generated SwiftUI block.")
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            \(styleSnippet(request.style))
            """
        )
    }

    private static func promptTitle(_ request: SwiftBlocksCraftRequest, fallback: String) -> String {
        let trimmed = request.prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return fallback }
        return trimmed.split(separator: " ").prefix(4).joined(separator: " ")
    }

    private static func node(
        _ kind: EDKComponentKind,
        x: Double,
        y: Double,
        width: Double,
        height: Double,
        title: String,
        subtitle: String = "",
        variant: EDKVariant,
        radius: Double
    ) -> EDKDesignNode {
        EDKDesignNode(
            kind: kind,
            frame: EDKDesignFrame(x: x, y: y, width: width, height: height),
            content: EDKComponentContent(title: title, subtitle: subtitle),
            style: EDKComponentStyle(variant: variant, size: .medium, cornerRadius: radius)
        )
    }

    private static func styleSnippet(_ style: SwiftBlocksCraftStyle) -> String {
        switch style {
        case .minimal:
            ".background(.background, in: RoundedRectangle(cornerRadius: 8))"
        case .glass:
            ".background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))"
        case .rounded:
            ".background(.background, in: RoundedRectangle(cornerRadius: 24))"
        case .gradient:
            ".background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 18))"
        case .outline:
            ".overlay(RoundedRectangle(cornerRadius: 12).stroke(.secondary.opacity(0.35)))"
        case .dashboard:
            ".background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))"
        case .iOSSettings:
            ".background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))"
        }
    }
}

private extension SwiftBlocksCraftStyle {
    var defaultVariant: EDKVariant {
        switch self {
        case .minimal, .outline, .iOSSettings:
            .primary
        case .glass:
            .glass
        case .rounded:
            .success
        case .gradient:
            .info
        case .dashboard:
            .dark
        }
    }

    var cardVariant: EDKVariant {
        switch self {
        case .glass:
            .glass
        case .dashboard:
            .dark
        default:
            .light
        }
    }

    var defaultRadius: Double {
        switch self {
        case .minimal: 8
        case .glass: 18
        case .rounded: 24
        case .gradient: 18
        case .outline: 12
        case .dashboard: 12
        case .iOSSettings: 12
        }
    }
}

public struct SwiftBlocksCraftTabView: View {
    @State private var request: SwiftBlocksCraftRequest
    @State private var result: SwiftBlocksCraftResult
    @State private var didCopy = false
    @State private var didAdd = false

    private let onAddToCanvas: ((EDKCraftedBlock) -> Void)?

    public init(
        request: SwiftBlocksCraftRequest = SwiftBlocksCraftRequest(),
        onAddToCanvas: ((EDKCraftedBlock) -> Void)? = nil
    ) {
        self._request = State(initialValue: request)
        self._result = State(initialValue: SwiftBlocksCraftGenerator.generate(from: request))
        self.onAddToCanvas = onAddToCanvas
    }

    public var body: some View {
        GeometryReader { proxy in
            if proxy.size.width > 820 {
                HStack(spacing: 0) {
                    controls
                        .frame(width: 330)
                    Divider()
                    previewAndCode
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        controls
                        previewAndCode
                    }
                    .padding()
                }
            }
        }
        .background(.background)
    }

    private var controls: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Craft")
                        .font(.title2.weight(.bold))
                    Text("Local SwiftUI component generation from presets and styles.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Prompt")
                        .font(.caption.weight(.semibold))
                    TextField("Describe a SwiftUI component, e.g. glass login button, pricing card, settings row...", text: $request.prompt, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Component Type")
                        .font(.caption.weight(.semibold))
                    Picker("Component Type", selection: $request.componentType) {
                        ForEach(SwiftBlocksCraftComponentType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Style")
                        .font(.caption.weight(.semibold))
                    Picker("Style", selection: $request.style) {
                        ForEach(SwiftBlocksCraftStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                actionButtons
            }
            .padding(18)
        }
        .background(.regularMaterial)
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button {
                generate()
            } label: {
                Label("Generate Component", systemImage: "wand.and.sparkles")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            HStack(spacing: 10) {
                Button {
                    onAddToCanvas?(SwiftBlocksCraftGenerator.craftedBlock(from: request))
                    didAdd = true
                } label: {
                    Label(didAdd ? "Added" : "Add to Canvas", systemImage: "plus.square.on.square")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    SwiftBlocksClipboard.copy(result.swiftUICode)
                    didCopy = true
                } label: {
                    Label(didCopy ? "Copied" : "Copy SwiftUI Code", systemImage: "doc.on.doc")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var previewAndCode: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Generated Preview")
                        .font(.headline)
                    SwiftBlocksGeneratedComponentPreview(request: request)
                        .frame(maxWidth: .infinity, minHeight: 220)
                        .padding(18)
                        .background(.background, in: RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.secondary.opacity(0.18))
                        }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.title)
                                .font(.headline)
                            Text(result.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }

                    ScrollView(.horizontal) {
                        Text(result.swiftUICode)
                            .font(.system(.caption, design: .monospaced))
                            .textSelection(.enabled)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.secondary.opacity(0.16))
                    }
                }
            }
            .padding(18)
        }
    }

    private func generate() {
        withAnimation(.snappy(duration: 0.2)) {
            result = SwiftBlocksCraftGenerator.generate(from: request)
            didCopy = false
            didAdd = false
        }
    }
}

private struct SwiftBlocksGeneratedComponentPreview: View {
    let request: SwiftBlocksCraftRequest

    var body: some View {
        VStack {
            switch request.componentType {
            case .button:
                Button(request.prompt.isEmpty ? "Continue" : request.prompt) {}
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
            case .card, .pricingCard:
                VStack(alignment: .leading, spacing: 12) {
                    Text(request.prompt.isEmpty ? request.componentType.rawValue : request.prompt)
                        .font(.title3.weight(.bold))
                    Text("Generated locally from SwiftBlocks presets.")
                        .foregroundStyle(.secondary)
                    Button("Continue") {}
                        .buttonStyle(.borderedProminent)
                }
                .padding(20)
                .frame(maxWidth: 320, alignment: .leading)
                .modifier(SwiftBlocksPreviewStyle(style: request.style))
            case .formRow, .settingsCell:
                HStack(spacing: 12) {
                    Image(systemName: request.componentType == .settingsCell ? "gearshape.fill" : "text.alignleft")
                        .foregroundStyle(.blue)
                    Text(request.prompt.isEmpty ? request.componentType.rawValue : request.prompt)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                .padding(14)
                .frame(maxWidth: 340)
                .modifier(SwiftBlocksPreviewStyle(style: request.style))
            case .heroSection, .profileHeader, .emptyState, .customBlock:
                VStack(alignment: .leading, spacing: 14) {
                    Text(request.prompt.isEmpty ? request.componentType.rawValue : request.prompt)
                        .font(.title.bold())
                    Text("A local SwiftUI structure generated without network calls.")
                        .foregroundStyle(.secondary)
                    Button("Add") {}
                        .buttonStyle(.borderedProminent)
                }
                .padding(22)
                .frame(maxWidth: 340, alignment: .leading)
                .modifier(SwiftBlocksPreviewStyle(style: request.style))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct SwiftBlocksPreviewStyle: ViewModifier {
    let style: SwiftBlocksCraftStyle

    func body(content: Content) -> some View {
        switch style {
        case .minimal:
            content.background(.background, in: RoundedRectangle(cornerRadius: 8))
        case .glass:
            content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
        case .rounded:
            content.background(.background, in: RoundedRectangle(cornerRadius: 24))
        case .gradient:
            content
                .foregroundStyle(.white)
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 18))
        case .outline:
            content.overlay(RoundedRectangle(cornerRadius: 12).stroke(.secondary.opacity(0.35)))
        case .dashboard:
            content.background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        case .iOSSettings:
            content.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

private enum SwiftBlocksClipboard {
    static func copy(_ string: String) {
        #if os(iOS)
        UIPasteboard.general.string = string
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(string, forType: .string)
        #endif
    }
}

#Preview("SwiftBlocks Craft Tab") {
    SwiftBlocksCraftTabView()
}
