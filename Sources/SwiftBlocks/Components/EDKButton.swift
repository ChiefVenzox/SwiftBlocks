import SwiftUI

public struct EDKButton<Label: View>: View {
    private let action: () -> Void
    private let label: Label
    private let style: EDKComponentStyle

    public init(
        style: EDKComponentStyle = EDKComponentStyle(),
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
        self.style = style
    }

    public var body: some View {
        Button(action: action) {
            label
        }
        .buttonStyle(EDKButtonStyle(style: style))
    }
}

public extension EDKButton where Label == Text {
    init(
        _ title: String,
        style: EDKComponentStyle = EDKComponentStyle(),
        action: @escaping () -> Void
    ) {
        self.init(style: style, action: action) {
            Text(title)
        }
    }
}

public struct EDKButtonStyle: ButtonStyle {
    @Environment(\.edkTheme) private var theme

    private let style: EDKComponentStyle

    public init(style: EDKComponentStyle = EDKComponentStyle()) {
        self.style = style
    }

    public func makeBody(configuration: Configuration) -> some View {
        let radius = CGFloat(style.cornerRadius)

        configuration.label
            .font(.system(size: style.size.fontSize, weight: .semibold, design: .rounded))
            .foregroundStyle(style.variant.foreground(in: theme))
            .lineLimit(1)
            .minimumScaleFactor(0.82)
            .padding(.horizontal, style.size.horizontalPadding)
            .padding(.vertical, style.size.verticalPadding)
            .frame(minHeight: style.size.minHeight)
            .edkSurfaceBackground(
                variant: style.variant,
                cornerRadius: radius,
                isInteractive: true,
                theme: theme
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.snappy(duration: 0.16), value: configuration.isPressed)
    }
}
