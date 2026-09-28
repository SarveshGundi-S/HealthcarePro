import UIKit

extension UIColor {

    convenience init(hex: String) {

        let hex = hex
            .trimmingCharacters(
                in: CharacterSet.alphanumerics.inverted
            )

        guard hex.count == 6 || hex.count == 8,
              let value = UInt64(hex, radix: 16) else {
            self.init(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 1
            )
            return
        }

        let red = CGFloat(
            (value >> (hex.count == 8 ? 24 : 16)) & 0xFF
        ) / 255.0

        let green = CGFloat(
            (value >> (hex.count == 8 ? 16 : 8)) & 0xFF
        ) / 255.0

        let blue = CGFloat(
            (value >> (hex.count == 8 ? 8 : 0)) & 0xFF
        ) / 255.0

        let alpha: CGFloat

        if hex.count == 8 {
            alpha = CGFloat(value & 0xFF) / 255.0
        } else {
            alpha = 1.0
        }

        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
}
