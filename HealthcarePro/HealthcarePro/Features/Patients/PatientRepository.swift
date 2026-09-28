import Foundation

protocol PatientRepository: Sendable {
    func fetchPatient(id: String) async throws -> Patient
}
