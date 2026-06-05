import SwiftUI

public struct EDKTheme: @unchecked Sendable {
    public var colors: EDKColorPalette
    public var spacing: EDKSpacingScale
    public var radii: EDKRadiusScale
    public var typography: EDKTypographyScale

    public init(
        colors: EDKColorPalette = .bootstrap,
        spacing: EDKSpacingScale = .default,
        radii: EDKRadiusScale = .default,
        typography: EDKTypographyScale = .default
    ) {
        self.colors = colors
        self.spacing = spacing
        self.radii = radii
        self.typography = typography
    }

    public static let bootstrap = EDKTheme()
}

public struct EDKColorPalette: @unchecked Sendable {
    public var primary: Color
    public var secondary: Color
    public var success: Color
    public var danger: Color
    public var warning: Color
    public var info: Color
    public var light: Color
    public var dark: Color
    public var canvas: Color
    public var stroke: Color

    public init(
        primary: Color,
        secondary: Color,
        success: Color,
        danger: Color,
        warning: Color,
        info: Color,
        light: Color,
        dark: Color,
        canvas: Color,
        stroke: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.success = success
        self.danger = danger
        self.warning = warning
        self.info = info
        self.light = light
        self.dark = dark
        self.canvas = canvas
        self.stroke = stroke
    }

    public static let bootstrap = EDKColorPalette(
        primary: Color(red: 0.05, green: 0.36, blue: 0.94),
        secondary: Color(red: 0.42, green: 0.46, blue: 0.50),
        success: Color(red: 0.10, green: 0.52, blue: 0.32),
        danger: Color(red: 0.86, green: 0.20, blue: 0.27),
        warning: Color(red: 1.00, green: 0.76, blue: 0.03),
        info: Color(red: 0.05, green: 0.64, blue: 0.74),
        light: Color(red: 0.97, green: 0.98, blue: 0.99),
        dark: Color(red: 0.13, green: 0.15, blue: 0.18),
        canvas: Color(red: 0.96, green: 0.97, blue: 0.98),
        stroke: Color(red: 0.82, green: 0.85, blue: 0.89)
    )
}

public struct EDKSpacingScale: Sendable {
    public var xxs: CGFloat
    public var xs: CGFloat
    public var sm: CGFloat
    public var md: CGFloat
    public var lg: CGFloat
    public var xl: CGFloat
    public var xxl: CGFloat

    public init(
        xxs: CGFloat = 4,
        xs: CGFloat = 8,
        sm: CGFloat = 12,
        md: CGFloat = 16,
        lg: CGFloat = 24,
        xl: CGFloat = 32,
        xxl: CGFloat = 48
    ) {
        self.xxs = xxs
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
    }

    public static let `default` = EDKSpacingScale()
}

public struct EDKRadiusScale: Sendable {
    public var sm: CGFloat
    public var md: CGFloat
    public var lg: CGFloat
    public var pill: CGFloat

    public init(sm: CGFloat = 6, md: CGFloat = 8, lg: CGFloat = 14, pill: CGFloat = 999) {
        self.sm = sm
        self.md = md
        self.lg = lg
        self.pill = pill
    }

    public static let `default` = EDKRadiusScale()
}

public struct EDKTypographyScale: Sendable {
    public var caption: CGFloat
    public var body: CGFloat
    public var title: CGFloat
    public var display: CGFloat

    public init(caption: CGFloat = 12, body: CGFloat = 16, title: CGFloat = 22, display: CGFloat = 34) {
        self.caption = caption
        self.body = body
        self.title = title
        self.display = display
    }

    public static let `default` = EDKTypographyScale()
}

private struct EDKThemeKey: EnvironmentKey {
    static let defaultValue = EDKTheme.bootstrap
}

public extension EnvironmentValues {
    var edkTheme: EDKTheme {
        get { self[EDKThemeKey.self] }
        set { self[EDKThemeKey.self] = newValue }
    }
}

public extension View {
    func edkTheme(_ theme: EDKTheme) -> some View {
        environment(\.edkTheme, theme)
    }
}
