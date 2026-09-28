import Foundation
@testable import HealthcarePro

final class MockPatientRepository: PatientRepository, @unchecked Sendable {

    var fetchPatientCallCount = 0
    var receivedPatientID: String?

    var patient: Patient?
    var fetchError: Error?

    func fetchPatient(id: String) async throws -> Patient {

        fetchPatientCallCount += 1
        receivedPatientID = id

        if let fetchError {
            throw fetchError
        }

        guard let patient else {
            fatalError("MockPatientRepository.patient must be configured before calling fetchPatient")
        }

        return patient
    }
}
