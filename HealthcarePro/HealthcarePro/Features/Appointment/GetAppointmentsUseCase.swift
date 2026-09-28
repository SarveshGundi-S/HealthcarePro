import Foundation

protocol GetAppointmentsUseCase {
    func execute(patientId: String) async throws -> [Appointment]
}

final class GetAppointmentsUseCaseImpl: GetAppointmentsUseCase {

    private let appointmentRepository: AppointmentRepository
    
    init(appointmentRepository: AppointmentRepository) {
        self.appointmentRepository = appointmentRepository
    }

    func execute(patientId: String) async throws -> [Appointment] {
        try await appointmentRepository.fetchAppointments(patientId: patientId)
    }
    
    
}
