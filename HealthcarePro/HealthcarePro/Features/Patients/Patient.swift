import Foundation

struct Patient: Sendable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let phoneNumber: String
    let email: String
}
