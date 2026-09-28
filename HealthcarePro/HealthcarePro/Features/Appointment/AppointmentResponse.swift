import Foundation

struct AppointmentResponse: Sendable {
    let id: String
    let patientId: String
    let doctorId: String
    let appointmentDate: String
    let status: String
}

nonisolated extension AppointmentResponse: Decodable {}

extension AppointmentResponse {
    func toDomain() -> Appointment {
        Appointment(id: id,
                    patientId: patientId,
                    doctorId: doctorId,
                    appointmentDate: appointmentDate,
                    status: status)
    }
}

struct BookAppointmentBody: Sendable {
    let patientId: String
    let doctorId: String
    let appointmentDate: String
}
nonisolated extension BookAppointmentBody: Encodable {}
