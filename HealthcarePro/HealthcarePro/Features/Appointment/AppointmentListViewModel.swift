import Foundation

@MainActor
final class AppointmentListViewModel {
    let getAppointmentsUseCase: GetAppointmentsUseCase

    private let patientId: String

    private(set) var appointments: [Appointment] = []
    
    private(set) var isLoading = false
    private(set) var error: Error?
    
    var onStateChange: (() -> Void)?
    
    init(patientId: String,
         getAppointmentsUseCase: GetAppointmentsUseCase) {
        self.patientId = patientId
        self.getAppointmentsUseCase = getAppointmentsUseCase
    }

    func loadAppointments() {
        guard !isLoading else {
            return
        }

        isLoading = true
        error = nil
        onStateChange?()

        Task {
            do {
                appointments = try await getAppointmentsUseCase.execute(patientId: patientId)
                
                isLoading = false
                onStateChange?()
            } catch {
                self.error = error
                isLoading = false
                onStateChange?()
            }
        }
    }
}
