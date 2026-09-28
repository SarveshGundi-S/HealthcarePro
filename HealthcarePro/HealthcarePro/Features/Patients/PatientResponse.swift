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
    func toDomain() -> Patient {
        Patient(id: id,
                firstName: firstName,
                lastName: lastName,
                dateOfBirth: dateOfBirth,
                phoneNumber: phoneNumber,
                email: email)
    }
}
