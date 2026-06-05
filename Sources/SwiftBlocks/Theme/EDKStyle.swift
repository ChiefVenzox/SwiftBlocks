import SwiftUI

public enum EDKVariant: String, CaseIterable, Codable, Identifiable, Sendable {
    case primary
    case secondary
    case success
    case danger
    case warning
    case info
    case light
    case dark
    case glass

    public var id: String { rawValue }

    public func background(in theme: EDKTheme) -> Color {
        switch self {
        case .primary: theme.colors.primary
        case .secondary: theme.colors.secondary
        case .success: theme.colors.success
        case .danger: theme.colors.danger
        case .warning: theme.colors.warning
        case .info: theme.colors.info
        case .light: theme.colors.light
        case .dark: theme.colors.dark
        case .glass: .clear
        }
    }

    public func foreground(in theme: EDKTheme) -> Color {
        switch self {
        case .warning, .light, .glass:
            theme.colors.dark
        default:
            .white
        }
    }
}

public enum EDKComponentSize: String, CaseIterable, Codable, Identifiable, Sendable {
    case small
    case medium
    case large

    public var id: String { rawValue }

    public var horizontalPadding: CGFloat {
        switch self {
        case .small: 12
        case .medium: 16
        case .large: 22
        }
    }

    public var verticalPadding: CGFloat {
        switch self {
        case .small: 7
        case .medium: 10
        case .large: 14
        }
    }

    public var minHeight: CGFloat {
        switch self {
        case .small: 32
        case .medium: 40
        case .large: 52
        }
    }

    public var fontSize: CGFloat {
        switch self {
        case .small: 14
        case .medium: 16
        case .large: 18
        }
    }
}

public struct EDKComponentStyle: Codable, Equatable, Sendable {
    public var variant: EDKVariant
    public var size: EDKComponentSize
    public var cornerRadius: Double

    public init(
        variant: EDKVariant = .primary,
        size: EDKComponentSize = .medium,
        cornerRadius: Double = 8
    ) {
        self.variant = variant
        self.size = size
        self.cornerRadius = cornerRadius
    }
}

extension View {
    @ViewBuilder
    func edkSurfaceBackground(
        variant: EDKVariant,
        cornerRadius: CGFloat,
        isInteractive: Bool,
        theme: EDKTheme
    ) -> some View {
        if variant == .glass {
            if #available(iOS 26.0, macOS 26.0, *) {
                if isInteractive {
                    self.glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
                } else {
                    self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
                }
            } else {
                self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(theme.colors.stroke.opacity(0.75), lineWidth: 1)
                    }
            }
        } else {
            self.background(variant.background(in: theme), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}
