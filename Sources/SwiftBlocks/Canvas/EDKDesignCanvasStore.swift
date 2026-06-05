import CoreGraphics
import Foundation
import Observation

@MainActor
@Observable
public final class EDKDesignCanvasStore {
    public var document: EDKDesignDocument
    public var selectedNodeID: EDKDesignNode.ID?

    public init(document: EDKDesignDocument = EDKDesignDocument()) {
        self.document = document
        self.selectedNodeID = document.nodes.first?.id
    }

    @discardableResult
    public func add(_ item: EDKPaletteItem, at point: CGPoint? = nil) -> EDKDesignNode.ID {
        let nodeID = document.addNode(item.makeNode(), at: point)
        selectedNodeID = nodeID
        return nodeID
    }

    public func updateFrame(id: EDKDesignNode.ID, frame: EDKDesignFrame) {
        document.updateFrame(id: id, frame: frame)
    }

    public func updateStyle(id: EDKDesignNode.ID, mutate: (inout EDKComponentStyle) -> Void) {
        document.updateStyle(id: id, mutate: mutate)
    }

    public func select(_ id: EDKDesignNode.ID?) {
        selectedNodeID = id
    }

    public func removeSelectedNode() {
        guard let selectedNodeID else { return }
        document.removeNode(id: selectedNodeID)
        self.selectedNodeID = document.nodes.last?.id
    }

    public var selectedNode: EDKDesignNode? {
        guard let selectedNodeID else { return nil }
        return document.nodes.first { $0.id == selectedNodeID }
    }

    public static func sample() -> EDKDesignCanvasStore {
        let button = EDKDesignNode(
            kind: .button,
            frame: EDKDesignFrame(x: 32, y: 56, width: 168, height: 52),
            content: EDKComponentContent(title: "Get Started"),
            style: EDKComponentStyle(variant: .primary, size: .medium, cornerRadius: 8)
        )
        let card = EDKDesignNode(
            kind: .card,
            frame: EDKDesignFrame(x: 32, y: 132, width: 288, height: 156),
            content: EDKComponentContent(title: "Glass Card", subtitle: "Live layout surface"),
            style: EDKComponentStyle(variant: .glass, size: .medium, cornerRadius: 14)
        )
        return EDKDesignCanvasStore(document: EDKDesignDocument(nodes: [button, card]))
    }
}
