import Foundation
import SwiftUI
import UniformTypeIdentifiers
#if canImport(FoundationModels)
import FoundationModels
#endif

public enum EDKCraftIntent: String, CaseIterable, Codable, Identifiable, Sendable {
    case button
    case header
    case card
    case landing

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .button: "Button"
        case .header: "Header"
        case .card: "Card"
        case .landing: "Landing"
        }
    }
}

public struct EDKCraftRequest: Codable, Equatable, Sendable {
    public var prompt: String
    public var intent: EDKCraftIntent
    public var variant: EDKVariant
    public var cornerRadius: Double

    public init(
        prompt: String = "",
        intent: EDKCraftIntent = .landing,
        variant: EDKVariant = .primary,
        cornerRadius: Double = 12
    ) {
        self.prompt = prompt
        self.intent = intent
        self.variant = variant
        self.cornerRadius = cornerRadius
    }
}

public struct EDKCraftedBlock: Codable, Equatable, Identifiable, Sendable, Transferable {
    public var id: UUID
    public var title: String
    public var summary: String
    public var width: Double
    public var height: Double
    public var nodes: [EDKDesignNode]

    public init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        width: Double,
        height: Double,
        nodes: [EDKDesignNode]
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.width = width
        self.height = height
        self.nodes = nodes
    }

    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .json)
    }
}

public struct EDKLocalAutoCraftEngine: Sendable {
    public init() {}

    public func craft(_ request: EDKCraftRequest) -> [EDKCraftedBlock] {
        switch request.intent {
        case .button:
            craftButtons(request)
        case .header:
            craftHeaders(request)
        case .card:
            craftCards(request)
        case .landing:
            craftLanding(request)
        }
    }

    private func craftButtons(_ request: EDKCraftRequest) -> [EDKCraftedBlock] {
        [
            EDKCraftedBlock(
                title: "Primary CTA",
                summary: "Single action button",
                width: 176,
                height: 56,
                nodes: [
                    node(
                        .button,
                        x: 0,
                        y: 0,
                        width: 176,
                        height: 56,
                        title: buttonTitle(from: request.prompt, fallback: "Continue"),
                        style: EDKComponentStyle(variant: request.variant, size: .large, cornerRadius: request.cornerRadius)
                    ),
                ]
            ),
            EDKCraftedBlock(
                title: "Button Pair",
                summary: "Primary and secondary actions",
                width: 292,
                height: 48,
                nodes: [
                    node(
                        .button,
                        x: 0,
                        y: 0,
                        width: 136,
                        height: 48,
                        title: buttonTitle(from: request.prompt, fallback: "Save"),
                        style: EDKComponentStyle(variant: request.variant, size: .medium, cornerRadius: request.cornerRadius)
                    ),
                    node(
                        .button,
                        x: 152,
                        y: 0,
                        width: 140,
                        height: 48,
                        title: "Cancel",
                        style: EDKComponentStyle(variant: .light, size: .medium, cornerRadius: request.cornerRadius)
                    ),
                ]
            ),
        ]
    }

    private func craftHeaders(_ request: EDKCraftRequest) -> [EDKCraftedBlock] {
        [
            EDKCraftedBlock(
                title: "Hero Header",
                summary: "Title, supporting copy, CTA",
                width: 320,
                height: 164,
                nodes: [
                    node(.text, x: 0, y: 0, width: 288, height: 44, title: headline(from: request.prompt, fallback: "Build faster")),
                    node(.card, x: 0, y: 54, width: 320, height: 66, title: "Local crafted layout", subtitle: "Generated on device as editable SwiftBlocks.", style: EDKComponentStyle(variant: .glass, size: .medium, cornerRadius: request.cornerRadius)),
                    node(.button, x: 0, y: 132, width: 154, height: 48, title: "Get Started", style: EDKComponentStyle(variant: request.variant, size: .medium, cornerRadius: request.cornerRadius)),
                ]
            ),
            EDKCraftedBlock(
                title: "Compact Header",
                summary: "Small title and action",
                width: 320,
                height: 92,
                nodes: [
                    node(.text, x: 0, y: 0, width: 188, height: 42, title: headline(from: request.prompt, fallback: "Dashboard")),
                    node(.button, x: 198, y: 0, width: 122, height: 42, title: "Create", style: EDKComponentStyle(variant: request.variant, size: .small, cornerRadius: request.cornerRadius)),
                    node(.card, x: 0, y: 52, width: 320, height: 40, title: "Ready", subtitle: "Drop into your canvas.", style: EDKComponentStyle(variant: .light, size: .small, cornerRadius: request.cornerRadius)),
                ]
            ),
        ]
    }

    private func craftCards(_ request: EDKCraftRequest) -> [EDKCraftedBlock] {
        [
            EDKCraftedBlock(
                title: "Feature Card",
                summary: "Glass surface with CTA",
                width: 288,
                height: 174,
                nodes: [
                    node(.card, x: 0, y: 0, width: 288, height: 118, title: headline(from: request.prompt, fallback: "Smart blocks"), subtitle: "Tune radius, color, and layout before dropping.", style: EDKComponentStyle(variant: .glass, size: .medium, cornerRadius: request.cornerRadius)),
                    node(.button, x: 16, y: 130, width: 144, height: 44, title: "Apply", style: EDKComponentStyle(variant: request.variant, size: .small, cornerRadius: request.cornerRadius)),
                ]
            ),
            EDKCraftedBlock(
                title: "Status Card",
                summary: "Semantic card with action",
                width: 288,
                height: 148,
                nodes: [
                    node(.card, x: 0, y: 0, width: 288, height: 148, title: "Auto Craft", subtitle: "Two local suggestions are ready to place.", style: EDKComponentStyle(variant: .light, size: .medium, cornerRadius: request.cornerRadius)),
                    node(.button, x: 142, y: 92, width: 126, height: 40, title: "Review", style: EDKComponentStyle(variant: request.variant, size: .small, cornerRadius: request.cornerRadius)),
                ]
            ),
        ]
    }

    private func craftLanding(_ request: EDKCraftRequest) -> [EDKCraftedBlock] {
        [
            EDKCraftedBlock(
                title: "Onboarding Stack",
                summary: "Header, copy, and CTA",
                width: 318,
                height: 238,
                nodes: [
                    node(.text, x: 0, y: 0, width: 286, height: 48, title: headline(from: request.prompt, fallback: "Design with blocks")),
                    node(.card, x: 0, y: 62, width: 318, height: 112, title: "Local Auto Craft", subtitle: "Create editable blocks without leaving Xcode previews.", style: EDKComponentStyle(variant: .glass, size: .medium, cornerRadius: request.cornerRadius)),
                    node(.button, x: 0, y: 190, width: 156, height: 48, title: "Craft", style: EDKComponentStyle(variant: request.variant, size: .medium, cornerRadius: request.cornerRadius)),
                    node(.button, x: 168, y: 190, width: 150, height: 48, title: "Preview", style: EDKComponentStyle(variant: .light, size: .medium, cornerRadius: request.cornerRadius)),
                ]
            ),
            EDKCraftedBlock(
                title: "Feature Panel",
                summary: "Card-led layout block",
                width: 318,
                height: 218,
                nodes: [
                    node(.card, x: 0, y: 0, width: 318, height: 154, title: headline(from: request.prompt, fallback: "SwiftUI Studio"), subtitle: "A composed block with semantic color and radius controls.", style: EDKComponentStyle(variant: .light, size: .medium, cornerRadius: request.cornerRadius)),
                    node(.button, x: 20, y: 170, width: 138, height: 48, title: "Insert", style: EDKComponentStyle(variant: request.variant, size: .medium, cornerRadius: request.cornerRadius)),
                ]
            ),
        ]
    }

    private func node(
        _ kind: EDKComponentKind,
        x: Double,
        y: Double,
        width: Double,
        height: Double,
        title: String,
        subtitle: String = "",
        style: EDKComponentStyle = EDKComponentStyle()
    ) -> EDKDesignNode {
        EDKDesignNode(
            kind: kind,
            frame: EDKDesignFrame(x: x, y: y, width: width, height: height),
            content: EDKComponentContent(title: title, subtitle: subtitle),
            style: style
        )
    }

    private func headline(from prompt: String, fallback: String) -> String {
        let trimmed = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return fallback }
        let words = trimmed.split(separator: " ").prefix(4).joined(separator: " ")
        return String(words.prefix(1)).uppercased() + String(words.dropFirst())
    }

    private func buttonTitle(from prompt: String, fallback: String) -> String {
        let lowercasedPrompt = prompt.lowercased()
        if lowercasedPrompt.contains("login") { return "Login" }
        if lowercasedPrompt.contains("save") { return "Save" }
        if lowercasedPrompt.contains("buy") { return "Buy Now" }
        if lowercasedPrompt.contains("start") { return "Start" }
        return fallback
    }
}

public enum EDKAutoCraftRuntime: Equatable, Sendable {
    case foundationModels
    case localTemplates(String)

    public var title: String {
        switch self {
        case .foundationModels:
            "Foundation Models"
        case .localTemplates:
            "Local Templates"
        }
    }

    public var message: String {
        switch self {
        case .foundationModels:
            "Using Apple's on-device language model."
        case .localTemplates(let reason):
            reason
        }
    }
}

public struct EDKAutoCraftOutput: Sendable {
    public var blocks: [EDKCraftedBlock]
    public var runtime: EDKAutoCraftRuntime

    public init(blocks: [EDKCraftedBlock], runtime: EDKAutoCraftRuntime) {
        self.blocks = blocks
        self.runtime = runtime
    }
}

public struct EDKAutoCraftCoordinator: Sendable {
    private let localEngine = EDKLocalAutoCraftEngine()

    public init() {}

    public func craft(_ request: EDKCraftRequest) async -> EDKAutoCraftOutput {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, macOS 26.0, visionOS 26.0, *) {
            let foundationEngine = EDKFoundationAutoCraftEngine()
            do {
                let blocks = try await foundationEngine.craft(request)
                return EDKAutoCraftOutput(blocks: blocks, runtime: .foundationModels)
            } catch {
                return EDKAutoCraftOutput(
                    blocks: localEngine.craft(request),
                    runtime: .localTemplates(foundationEngine.fallbackReason(after: error))
                )
            }
        }
        #endif

        return EDKAutoCraftOutput(
            blocks: localEngine.craft(request),
            runtime: .localTemplates("Foundation Models requires iOS 26/macOS 26 and Apple Intelligence.")
        )
    }
}

#if canImport(FoundationModels)
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
public struct EDKFoundationAutoCraftEngine: Sendable {
    private let model = SystemLanguageModel.default

    public init() {}

    public func fallbackReason(after error: Error? = nil) -> String {
        if let error {
            return "Foundation Models failed, using local templates. \(error.localizedDescription)"
        }

        switch model.availability {
        case .available:
            return "Foundation Models is available."
        case .unavailable(.deviceNotEligible):
            return "This device is not eligible for Apple Intelligence, using local templates."
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Apple Intelligence is off, using local templates."
        case .unavailable(.modelNotReady):
            return "The on-device model is not ready yet, using local templates."
        case .unavailable:
            return "Foundation Models is unavailable, using local templates."
        }
    }

    public func craft(_ request: EDKCraftRequest) async throws -> [EDKCraftedBlock] {
        guard case .available = model.availability else {
            throw EDKFoundationAutoCraftError.unavailable(fallbackReason())
        }

        let session = LanguageModelSession(
            model: model,
            instructions: """
            You create editable SwiftUI layout blocks for SwiftBlocks.
            Return exactly two practical suggestions.
            Use only supported node kinds: button, text, card, hStack, vStack, spacer.
            Use only supported variants: primary, secondary, success, danger, warning, info, light, dark, glass.
            Use compact frames that fit inside a 390 by 844 iPhone canvas.
            Prefer useful titles, headers, buttons, and cards that match the user's prompt.
            """
        )

        let response = try await session.respond(
            to: prompt(for: request),
            generating: EDKGeneratedCraftPlan.self,
            options: GenerationOptions(
                sampling: .random(probabilityThreshold: 0.92),
                temperature: 0.7,
                maximumResponseTokens: 900
            )
        )

        let blocks = response.content.blocks.map { $0.makeBlock(fallback: request) }
        guard blocks.count == 2, blocks.allSatisfy({ !$0.nodes.isEmpty }) else {
            throw EDKFoundationAutoCraftError.invalidOutput
        }
        return blocks
    }

    private func prompt(for request: EDKCraftRequest) -> String {
        """
        User prompt: \(request.prompt.isEmpty ? "Create a useful iOS UI block." : request.prompt)
        Requested block type: \(request.intent.rawValue)
        Preferred semantic color: \(request.variant.rawValue)
        Preferred corner radius: \(Int(request.cornerRadius))
        Generate two different SwiftBlocks suggestions.
        """
    }
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
public enum EDKFoundationAutoCraftError: LocalizedError, Sendable {
    case unavailable(String)
    case invalidOutput

    public var errorDescription: String? {
        switch self {
        case .unavailable(let reason):
            reason
        case .invalidOutput:
            "The generated block plan was incomplete."
        }
    }
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@Generable
struct EDKGeneratedCraftPlan {
    @Guide(description: "Exactly two block suggestions.", .count(2))
    var blocks: [EDKGeneratedCraftBlock]
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@Generable
struct EDKGeneratedCraftBlock {
    @Guide(description: "Short name for this block suggestion.")
    var title: String

    @Guide(description: "One short sentence explaining the block.")
    var summary: String

    @Guide(description: "Approximate block width.", .range(120.0...340.0))
    var width: Double

    @Guide(description: "Approximate block height.", .range(40.0...320.0))
    var height: Double

    @Guide(description: "Two to five editable nodes.", .count(2...5))
    var nodes: [EDKGeneratedCraftNode]

    func makeBlock(fallback request: EDKCraftRequest) -> EDKCraftedBlock {
        EDKCraftedBlock(
            title: title,
            summary: summary,
            width: width.clamped(to: 120...340),
            height: height.clamped(to: 40...320),
            nodes: nodes.map { $0.makeNode(fallback: request) }
        )
    }
}

@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@Generable
struct EDKGeneratedCraftNode {
    @Guide(description: "Node kind.", .anyOf(["button", "text", "card", "hStack", "vStack", "spacer"]))
    var kind: String

    @Guide(description: "Text shown in the node.")
    var title: String

    @Guide(description: "Optional supporting text.")
    var subtitle: String

    @Guide(description: "X position relative to the block.", .range(0.0...340.0))
    var x: Double

    @Guide(description: "Y position relative to the block.", .range(0.0...320.0))
    var y: Double

    @Guide(description: "Node width.", .range(40.0...340.0))
    var width: Double

    @Guide(description: "Node height.", .range(32.0...220.0))
    var height: Double

    @Guide(description: "Semantic color variant.", .anyOf(["primary", "secondary", "success", "danger", "warning", "info", "light", "dark", "glass"]))
    var variant: String

    @Guide(description: "Component size.", .anyOf(["small", "medium", "large"]))
    var size: String

    @Guide(description: "Corner radius.", .range(0.0...28.0))
    var cornerRadius: Double

    func makeNode(fallback request: EDKCraftRequest) -> EDKDesignNode {
        EDKDesignNode(
            kind: EDKComponentKind(rawValue: kind) ?? request.intent.fallbackKind,
            frame: EDKDesignFrame(
                x: x.clamped(to: 0...340),
                y: y.clamped(to: 0...320),
                width: width.clamped(to: 40...340),
                height: height.clamped(to: 32...220)
            ),
            content: EDKComponentContent(title: title, subtitle: subtitle),
            style: EDKComponentStyle(
                variant: EDKVariant(rawValue: variant) ?? request.variant,
                size: EDKComponentSize(rawValue: size) ?? .medium,
                cornerRadius: cornerRadius.clamped(to: 0...28)
            )
        )
    }
}

private extension EDKCraftIntent {
    var fallbackKind: EDKComponentKind {
        switch self {
        case .button: .button
        case .header: .text
        case .card: .card
        case .landing: .card
        }
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
#endif
