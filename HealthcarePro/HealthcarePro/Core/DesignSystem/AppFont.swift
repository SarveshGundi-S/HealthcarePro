import UIKit

final class AppFont {
    private init() {}
    static private(set) var title1: UIFont!
    static private(set) var body: UIFont!
    static private(set) var caption: UIFont!
    
    static func configure(with configuration: TypographyConfiguration) {
        title1 = .systemFont(ofSize: configuration.title.fontSize, weight: configuration.title.fontWeight.uiFontWeight)
        body = .systemFont(ofSize: configuration.body.fontSize, weight: configuration.body.fontWeight.uiFontWeight)
        caption = .systemFont(ofSize: configuration.caption.fontSize, weight: configuration.caption.fontWeight.uiFontWeight)
    }
}
