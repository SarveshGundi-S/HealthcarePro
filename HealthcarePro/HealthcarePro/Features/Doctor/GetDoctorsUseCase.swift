import Foundation

protocol GetDoctorsUseCase {
    func execute() async throws -> [Doctor]
}

final class GetDoctorsUseCaseImpl: GetDoctorsUseCase {

    private let doctorRepository: DoctorRepository
    
    init(doctorRepository: DoctorRepository) {
        self.doctorRepository = doctorRepository
    }

    func execute() async throws -> [Doctor] {
        try await doctorRepository.fetchDoctors()
    }
}
