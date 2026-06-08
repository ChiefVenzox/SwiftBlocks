import Foundation
import SwiftUI
import UniformTypeIdentifiers

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
                    node(.card, x: 0, y: 54, width: 320, height: 66, title: "Local crafted layout", subtitle: "Generated locally as editable SwiftBlocks.", style: EDKComponentStyle(variant: .glass, size: .medium, cornerRadius: request.cornerRadius)),
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
                    node(.card, x: 0, y: 0, width: 318, height: 154, title: headline(from: request.prompt, fallback: "SwiftBlocks"), subtitle: "A composed block with semantic color and radius controls.", style: EDKComponentStyle(variant: .light, size: .medium, cornerRadius: request.cornerRadius)),
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
