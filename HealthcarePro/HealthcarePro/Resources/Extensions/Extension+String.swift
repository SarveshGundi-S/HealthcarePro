import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self,
                          comment: "")
    }
}

extension String {

    func formattedDate(as format: DateFormat) -> String? {

        let formatter = DateFormatter()

        guard let date = formatter.date(from: self) else {
            return nil
        }
        formatter.locale = Locale.current
        formatter.dateFormat = format.dateFormat

        return formatter.string(from: date)
    }
}

enum DateFormat {
    case short
    case long
    case custom(String)

    var dateFormat: String {
        switch self {
        case .short:
            return "dd MMM yyyy"
        case .long:
            return "dd MMMM yyyy"
        case .custom(let format):
            return format
        }
    }
}
