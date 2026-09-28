import UIKit

final class AppColor {
    private init() {}

    static private(set) var primary: UIColor!
    static private(set) var background: UIColor!
    static private(set) var surface: UIColor!
    static private(set) var textPrimary: UIColor!
    static private(set) var textSecondary: UIColor!
    static private(set) var error: UIColor!

    static func configure(with configuration: ColorConfiguration) {
        primary = UIColor(hex: configuration.primary)
        background = UIColor(hex: configuration.background)
        surface = UIColor(hex: configuration.surface)
        textPrimary = UIColor(hex: configuration.textPrimary)
        textSecondary = UIColor(hex: configuration.textSecondary)
        error = UIColor(hex: configuration.error)
    }
}
