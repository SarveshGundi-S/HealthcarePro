import Foundation

struct Doctor: Sendable, Identifiable {

    let id: String
    let firstName: String
    let lastName: String
    let specialization: String

    var displayName: String {
        "Dr. \(firstName) \(lastName)"
    }
}
