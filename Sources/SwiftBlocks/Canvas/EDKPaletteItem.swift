import SwiftUI
import UniformTypeIdentifiers

public struct EDKPaletteItem: Codable, Hashable, Identifiable, Sendable, Transferable {
    public var kind: EDKComponentKind
    public var variant: EDKVariant

    public init(kind: EDKComponentKind, variant: EDKVariant = .primary) {
        self.kind = kind
        self.variant = variant
    }

    public var id: String {
        "\(kind.rawValue)-\(variant.rawValue)"
    }

    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .json)
    }

    public static let basic: [EDKPaletteItem] = [
        EDKPaletteItem(kind: .button, variant: .primary),
        EDKPaletteItem(kind: .button, variant: .success),
        EDKPaletteItem(kind: .text, variant: .dark),
        EDKPaletteItem(kind: .card, variant: .glass),
        EDKPaletteItem(kind: .hStack, variant: .light),
        EDKPaletteItem(kind: .vStack, variant: .light),
        EDKPaletteItem(kind: .spacer, variant: .secondary),
    ]

    public func makeNode() -> EDKDesignNode {
        EDKDesignNode(
            kind: kind,
            style: EDKComponentStyle(
                variant: variant,
                size: .medium,
                cornerRadius: kind == .button ? 8 : 12
            )
        )
    }
}
