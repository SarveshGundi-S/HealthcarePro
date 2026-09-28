import Foundation

extension Date {

    func formatted(as format: DateFormat) -> String {

        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format.dateFormat

        return formatter.string(from: self)
    }
}
