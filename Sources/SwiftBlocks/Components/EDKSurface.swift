import SwiftUI

public struct EDKSurface<Content: View>: View {
    @Environment(\.edkTheme) private var theme

    private let style: EDKComponentStyle
    private let content: Content

    public init(
        style: EDKComponentStyle = EDKComponentStyle(variant: .light, size: .medium, cornerRadius: 8),
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
    }

    public var body: some View {
        content
            .padding(theme.spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .edkSurfaceBackground(
                variant: style.variant,
                cornerRadius: CGFloat(style.cornerRadius),
                isInteractive: false,
                theme: theme
            )
            .overlay {
                if style.variant != .glass {
                    RoundedRectangle(cornerRadius: CGFloat(style.cornerRadius), style: .continuous)
                        .stroke(theme.colors.stroke, lineWidth: 1)
                }
            }
    }
}
