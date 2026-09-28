import UIKit

struct ThemeConfiguration: Decodable, Sendable {

    let colors: ColorConfiguration
    let typography: TypographyConfiguration
    let spacing: SpacingConfiguration
}

struct ColorConfiguration: Decodable, Sendable {

    let primary: String
    let background: String
    let surface: String
    let textPrimary: String
    let textSecondary: String
    let error: String
}

struct TypographyConfiguration: Decodable, Sendable {

    let title: TypographyStyle
    let body: TypographyStyle
    let caption: TypographyStyle
}

struct TypographyStyle: Decodable, Sendable {

    let fontSize: Double
    let fontWeight: FontWeight
}

enum FontWeight: String, Decodable, Sendable {

    case regular
    case medium
    case semibold
    case bold
}

struct SpacingConfiguration: Decodable, Sendable {

    let small: Double
    let medium: Double
    let large: Double
    let extraLarge: Double
}

extension FontWeight {
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        }
    }
}
