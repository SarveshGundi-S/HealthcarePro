import Foundation

struct DoctorResponse: Sendable {

    let id: String
    let firstName: String
    let lastName: String
    let specialization: String
}

nonisolated extension DoctorResponse: Decodable {}

extension DoctorResponse {
    func toDomain() -> Doctor {
        Doctor(id: id,
               firstName: firstName,
               lastName: lastName,
               specialization: specialization)
    }
}
