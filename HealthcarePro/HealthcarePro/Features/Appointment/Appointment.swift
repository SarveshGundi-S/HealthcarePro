import Foundation

struct Appointment: Sendable, Identifiable {

    let id: String
    let patientId: String
    let doctorId: String
    let appointmentDate: String
    let status: String
}
