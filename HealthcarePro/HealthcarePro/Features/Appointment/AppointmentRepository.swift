import Foundation

protocol AppointmentRepository {
    func bookAppointment(patientId: String,
                         doctorId: String,
                         appointmentDate: String) async throws -> Appointment

    func fetchAppointments(patientId: String) async throws -> [Appointment]
}

final class AppointmentRepositoryImpl: AppointmentRepository {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func bookAppointment(patientId: String, doctorId: String, appointmentDate: String) async throws -> Appointment {
        let request = BookAppointmentRequest(body: BookAppointmentBody(patientId: patientId,
                                                                       doctorId: doctorId,
                                                                       appointmentDate: appointmentDate))
        let response = try await networkClient.send(request)
        
        return response.toDomain()
    }

    func fetchAppointments(patientId: String) async throws -> [Appointment] {
        let request = GetAppointmentsRequest(patientId: patientId)
        let response = try await networkClient.send(request)
        
        return response.map { $0.toDomain() }
    }
}
