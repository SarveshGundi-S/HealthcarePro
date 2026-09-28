import Foundation

@testable import HealthcarePro

final class MockAppointmentRepository: AppointmentRepository, @unchecked Sendable {

    var bookAppointmentCallCount = 0
    var receivedPatientID: String?
    var receivedDoctorID: String?
    var receivedAppointmentDate: String?

    var appointment: Appointment?
    var bookAppointmentError: Error?

    func bookAppointment(
        patientId: String,
        doctorId: String,
        appointmentDate: String
    ) async throws -> Appointment {

        bookAppointmentCallCount += 1

        receivedPatientID = patientId
        receivedDoctorID = doctorId
        receivedAppointmentDate = appointmentDate

        if let bookAppointmentError {
            throw bookAppointmentError
        }

        guard let appointment else {
            fatalError(
                "MockAppointmentRepository.appointment must be configured before calling bookAppointment"
            )
        }

        return appointment
    }

    func fetchAppointments(
        patientId: String
    ) async throws -> [Appointment] {
        []
    }
}
