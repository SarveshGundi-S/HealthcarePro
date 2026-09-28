import Foundation

@MainActor
final class PatientViewModel {
    private let getPatientUseCase: GetPatientUseCase
    
    private(set) var patient: Patient?

    private(set) var isLoading = false
    
    private(set) var error: Error?

    var onStateChange: (()->Void)?

    init(getPatientUseCase: GetPatientUseCase) {
        self.getPatientUseCase = getPatientUseCase
    }

    func fetchPatient(patientId: String) {
        isLoading = true
        error = nil
        onStateChange?()
        Task {
            do {
                let patient = try await getPatientUseCase.execute(patientID: patientId)
                self.patient = patient
                self.isLoading = false
                self.onStateChange?()
            } catch {
                self.error = error
                self.isLoading = false
                self.onStateChange?()
            }
        }
    }

//    func fetchPatient(patientId: String) {
//
//        isLoading = true
//        error = nil
//        onStateChange?()
//
//        Task { @MainActor in
//
//            try? await Task.sleep(for: .milliseconds(500))
//
//            self.patient = Patient(
//                id: "P001",
//                firstName: "Sarvesh",
//                lastName: "Gundi",
//                dateOfBirth: "14 FEB 1993",
//                phoneNumber: "+91 98765 43210",
//                email: "sgundi@example.com"
//            )
//
//            self.isLoading = false
//            self.onStateChange?()
//        }
//    }
    
}
