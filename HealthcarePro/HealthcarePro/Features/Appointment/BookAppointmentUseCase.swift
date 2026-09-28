import Foundation

protocol BookAppointmentUseCase {
    func execute(patientId: String,
                 doctorId: String,
                 appointmentDate: String) async throws -> Appointment
}

final class BookAppointmentUseCaseImpl: BookAppointmentUseCase {
    private let appointmentRepository: AppointmentRepository
    
    init(appointmentRepository: AppointmentRepository) {
        self.appointmentRepository = appointmentRepository
    }

    func execute(patientId: String,
                 doctorId: String,
                 appointmentDate: String) async throws -> Appointment {
        try await appointmentRepository.bookAppointment(patientId: patientId,
                                              doctorId: doctorId,
                                              appointmentDate: appointmentDate)
    }
}
