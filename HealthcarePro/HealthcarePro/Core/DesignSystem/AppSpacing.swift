import UIKit

final class AppSpacing {
    private init() {}
    
    static private(set) var small: CGFloat!
    static private(set) var medium: CGFloat!
    static private(set) var large: CGFloat!
    static private(set) var extraLarge: CGFloat!
    
    static func configure(with configuration: SpacingConfiguration) {
        small = configuration.small
        medium = configuration.medium
        large = configuration.large
        extraLarge = configuration.extraLarge
    }
}
