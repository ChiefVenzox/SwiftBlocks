#if canImport(DeveloperToolsSupport)
@preconcurrency import DeveloperToolsSupport
import SwiftUI

struct SwiftBlocksLibraryContent: LibraryContentProvider {
    var views: [LibraryItem] {
        [
            LibraryItem(
                MainActor.assumeIsolated {
                    EDKButton("Continue", style: EDKComponentStyle(variant: .primary, size: .medium, cornerRadius: 8)) {}
                },
                title: "SwiftBlocks Button",
                category: .control
            ),
            LibraryItem(
                MainActor.assumeIsolated {
                    EDKSurface(style: EDKComponentStyle(variant: .glass, size: .medium, cornerRadius: 14)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Glass Card")
                                .font(.headline)
                            Text("Editable SwiftBlocks surface")
                                .font(.subheadline)
                        }
                    }
                },
                title: "SwiftBlocks Glass Card",
                category: .other
            ),
            LibraryItem(
                MainActor.assumeIsolated {
                    EDKDesignCanvas()
                },
                title: "SwiftBlocks Canvas",
                category: .layout
            ),
            LibraryItem(
                MainActor.assumeIsolated {
                    SwiftBlocksCraftWindow()
                },
                title: "SwiftBlocks Auto Craft",
                category: .other
            ),
            LibraryItem(
                MainActor.assumeIsolated {
                    SwiftBlocksWorkspaceView(selectedTab: .craft)
                },
                title: "SwiftBlocks Workspace",
                category: .other
            ),
        ]
    }
}
#endif
