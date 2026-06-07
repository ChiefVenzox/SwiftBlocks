import CoreGraphics
import Foundation

public enum EDKComponentKind: String, CaseIterable, Codable, Identifiable, Sendable {
    case button
    case text
    case card
    case hStack
    case vStack
    case spacer

    public var id: String { rawValue }

    public var defaultTitle: String {
        switch self {
        case .button: "Button"
        case .text: "Title"
        case .card: "Card"
        case .hStack: "Horizontal"
        case .vStack: "Vertical"
        case .spacer: "Spacer"
        }
    }

    public var defaultFrame: EDKDesignFrame {
        switch self {
        case .button:
            EDKDesignFrame(x: 40, y: 40, width: 144, height: 48)
        case .text:
            EDKDesignFrame(x: 40, y: 40, width: 180, height: 44)
        case .card:
            EDKDesignFrame(x: 40, y: 40, width: 240, height: 150)
        case .hStack, .vStack:
            EDKDesignFrame(x: 40, y: 40, width: 260, height: 118)
        case .spacer:
            EDKDesignFrame(x: 40, y: 40, width: 120, height: 40)
        }
    }
}

public struct EDKComponentContent: Codable, Equatable, Sendable {
    public var title: String
    public var subtitle: String

    public init(title: String, subtitle: String = "") {
        self.title = title
        self.subtitle = subtitle
    }
}

public struct EDKDesignFrame: Codable, Equatable, Sendable {
    public var x: Double
    public var y: Double
    public var width: Double
    public var height: Double

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    public func movedBy(x deltaX: Double, y deltaY: Double) -> EDKDesignFrame {
        EDKDesignFrame(x: x + deltaX, y: y + deltaY, width: width, height: height)
    }

    public func resizedBy(width deltaWidth: Double, height deltaHeight: Double, minimumSize: CGSize) -> EDKDesignFrame {
        EDKDesignFrame(
            x: x,
            y: y,
            width: max(Double(minimumSize.width), width + deltaWidth),
            height: max(Double(minimumSize.height), height + deltaHeight)
        )
    }

    public func clamped(to canvasSize: CGSize) -> EDKDesignFrame {
        let clampedWidth = min(width, max(1, Double(canvasSize.width)))
        let clampedHeight = min(height, max(1, Double(canvasSize.height)))
        let clampedX = min(max(0, x), max(0, Double(canvasSize.width) - clampedWidth))
        let clampedY = min(max(0, y), max(0, Double(canvasSize.height) - clampedHeight))
        return EDKDesignFrame(x: clampedX, y: clampedY, width: clampedWidth, height: clampedHeight)
    }
}

public struct EDKDesignNode: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var kind: EDKComponentKind
    public var frame: EDKDesignFrame
    public var content: EDKComponentContent
    public var style: EDKComponentStyle

    public init(
        id: UUID = UUID(),
        kind: EDKComponentKind,
        frame: EDKDesignFrame? = nil,
        content: EDKComponentContent? = nil,
        style: EDKComponentStyle = EDKComponentStyle()
    ) {
        self.id = id
        self.kind = kind
        self.frame = frame ?? kind.defaultFrame
        self.content = content ?? EDKComponentContent(title: kind.defaultTitle)
        self.style = style
    }
}

public struct EDKDesignDocument: Codable, Equatable, Sendable {
    public var canvasWidth: Double
    public var canvasHeight: Double
    public var nodes: [EDKDesignNode]

    public init(canvasWidth: Double = 390, canvasHeight: Double = 844, nodes: [EDKDesignNode] = []) {
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        self.nodes = nodes
    }

    @discardableResult
    public mutating func addNode(_ node: EDKDesignNode, at point: CGPoint? = nil) -> EDKDesignNode.ID {
        var nextNode = node
        nextNode.id = UUID()
        if let point {
            nextNode.frame.x = Double(point.x) - nextNode.frame.width / 2
            nextNode.frame.y = Double(point.y) - nextNode.frame.height / 2
        }
        nextNode.frame = nextNode.frame.clamped(to: canvasSize)
        nodes.append(nextNode)
        return nextNode.id
    }

    @discardableResult
    public mutating func addBlock(_ block: EDKCraftedBlock, at point: CGPoint? = nil) -> [EDKDesignNode.ID] {
        let originX: Double
        let originY: Double

        if let point {
            originX = Double(point.x) - block.width / 2
            originY = Double(point.y) - block.height / 2
        } else {
            originX = 40
            originY = 40
        }

        let insertedNodes = block.nodes.map { sourceNode in
            var node = sourceNode
            node.id = UUID()
            node.frame.x += originX
            node.frame.y += originY
            node.frame = node.frame.clamped(to: canvasSize)
            return node
        }

        nodes.append(contentsOf: insertedNodes)
        return insertedNodes.map(\.id)
    }

    public mutating func updateFrame(id: EDKDesignNode.ID, frame: EDKDesignFrame) {
        guard let index = nodes.firstIndex(where: { $0.id == id }) else { return }
        nodes[index].frame = frame.clamped(to: canvasSize)
    }

    public mutating func updateStyle(id: EDKDesignNode.ID, mutate: (inout EDKComponentStyle) -> Void) {
        guard let index = nodes.firstIndex(where: { $0.id == id }) else { return }
        mutate(&nodes[index].style)
    }

    public mutating func removeNode(id: EDKDesignNode.ID) {
        nodes.removeAll { $0.id == id }
    }

    public var canvasSize: CGSize {
        CGSize(width: canvasWidth, height: canvasHeight)
    }
}
