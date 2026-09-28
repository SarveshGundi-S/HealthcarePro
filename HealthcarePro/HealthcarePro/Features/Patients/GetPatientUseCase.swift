import Foundation

protocol GetPatientUseCase: Sendable {
    func execute(patientID: String) async throws -> Patient
}

final class GetPatientUseCaseImpl: GetPatientUseCase {
    private let patientRepository: PatientRepository

    init(patientRepository: PatientRepository) {
        self.patientRepository = patientRepository
    }

    func execute(patientID: String) async throws -> Patient {
        try await patientRepository.fetchPatient(id: patientID)
    }
}
