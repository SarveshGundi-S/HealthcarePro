import Foundation

struct PatientResponse: Sendable {

    let id: String
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let phoneNumber: String
    let email: String
}

nonisolated extension PatientResponse: Decodable {
}
