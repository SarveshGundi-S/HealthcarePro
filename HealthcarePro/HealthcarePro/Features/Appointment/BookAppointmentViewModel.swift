import Foundation

enum AppointmentValidationError: Error, Sendable {
    case doctorRequired
    case invalidAppointmentDate
}

final class BookAppointmentViewModel {
    private let bookAppointmentUseCase: BookAppointmentUseCase
    
    private let patientId: String

    private(set) var selectedDoctor: Doctor?
    
    private(set) var isLoading = false
    private(set) var error: Error?
    private(set) var appointment: Appointment?
    
    var onStateChange: (() -> Void)?
    var onBookingSuccess: ((Appointment) -> Void)?

    init(patientId: String,
         bookAppointmentUseCase: BookAppointmentUseCase) {
        self.bookAppointmentUseCase = bookAppointmentUseCase
        self.patientId = patientId
    }

    func selectDoctor(_ doctor: Doctor) {

        selectedDoctor = doctor
        onStateChange?()
    }

    func bookAppointment(appointmentDate: Date) {
        guard let selectedDoctor else {
            showError(.doctorRequired)
            return
        }
        
        guard appointmentDate > Date() else {
            showError(.invalidAppointmentDate)
            return
        }

        let appointmentDateString = appointmentDate.formatted(as: .short)
        
        isLoading = true
        error = nil
        onStateChange?()
        
        Task {
            do {
                let appointment = try await bookAppointmentUseCase.execute(
                    patientId: patientId,
                    doctorId: selectedDoctor.id,
                    appointmentDate: appointmentDateString)
                self.appointment = appointment
                self.isLoading = false

                onStateChange?()
                onBookingSuccess?(appointment)
            } catch {
                self.error = error
                isLoading = false
                onStateChange?()
            }
        }
    }

    private func showError(_ error: AppointmentValidationError) {
        self.error = error
        onStateChange?()
    }
}
