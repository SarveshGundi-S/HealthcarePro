import Foundation

struct AppointmentDraft: Sendable {

    let patientId: String
    let doctor: Doctor
    let appointmentDate: Date
}
