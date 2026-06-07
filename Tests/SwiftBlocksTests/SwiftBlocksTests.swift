import CoreGraphics
import Testing
@testable import SwiftBlocks

@Test func documentAddsNodeAtDropPoint() throws {
    var document = EDKDesignDocument(canvasWidth: 320, canvasHeight: 640)
    let node = EDKPaletteItem(kind: .button, variant: .primary).makeNode()

    let nodeID = document.addNode(node, at: CGPoint(x: 160, y: 120))

    let addedNode = try #require(document.nodes.first { $0.id == nodeID })
    #expect(addedNode.frame.x == 88)
    #expect(addedNode.frame.y == 96)
}

@Test func documentClampsMovedFrameToCanvas() throws {
    var document = EDKDesignDocument(canvasWidth: 200, canvasHeight: 200)
    let nodeID = document.addNode(EDKDesignNode(kind: .card))

    document.updateFrame(
        id: nodeID,
        frame: EDKDesignFrame(x: 180, y: 190, width: 80, height: 80)
    )

    let node = try #require(document.nodes.first { $0.id == nodeID })
    #expect(node.frame.x == 120)
    #expect(node.frame.y == 120)
}

@Test func documentUpdatesNodeStyle() throws {
    var document = EDKDesignDocument()
    let nodeID = document.addNode(EDKDesignNode(kind: .button))

    document.updateStyle(id: nodeID) { style in
        style.variant = .success
        style.size = .large
    }

    let node = try #require(document.nodes.first { $0.id == nodeID })
    #expect(node.style.variant == .success)
    #expect(node.style.size == .large)
}

@Test func localAutoCraftCreatesTwoSuggestions() {
    let engine = EDKLocalAutoCraftEngine()
    let request = EDKCraftRequest(prompt: "login header", intent: .header, variant: .success, cornerRadius: 18)

    let blocks = engine.craft(request)

    #expect(blocks.count == 2)
    #expect(blocks.allSatisfy { !$0.nodes.isEmpty })
    #expect(blocks.flatMap(\.nodes).contains { $0.style.cornerRadius == 18 })
}

@Test func documentAddsCraftedBlockWithFreshIDs() throws {
    let engine = EDKLocalAutoCraftEngine()
    let block = try #require(engine.craft(EDKCraftRequest(intent: .button)).first)
    var document = EDKDesignDocument(canvasWidth: 390, canvasHeight: 844)

    let firstIDs = document.addBlock(block, at: CGPoint(x: 100, y: 100))
    let secondIDs = document.addBlock(block, at: CGPoint(x: 100, y: 180))

    #expect(firstIDs.count == block.nodes.count)
    #expect(secondIDs.count == block.nodes.count)
    #expect(Set(firstIDs).isDisjoint(with: Set(secondIDs)))
    #expect(document.nodes.count == block.nodes.count * 2)
}
