import Foundation

@MainActor
final class DoctorSelectionViewModel {
    private let getDoctorsUseCase: GetDoctorsUseCase

    private(set) var doctors: [Doctor] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    
    var onStateChange: (() -> Void)?
    var onDoctorSelected: ((Doctor) -> Void)?

    
    init(getDoctorsUseCase: GetDoctorsUseCase) {
        self.getDoctorsUseCase = getDoctorsUseCase
    }

    func loadDoctors() {
        guard !isLoading else {
            return
        }

        isLoading = true
        error = nil
        onStateChange?()
        Task {
            do {
                doctors = try await getDoctorsUseCase.execute()

                isLoading = false
                onStateChange?()
            } catch {
                self.error = error
                isLoading = false
                onStateChange?()
            }
        }
    }

    func selectDoctor(at index: Int) {
        guard doctors.indices.contains(index) else {
            return
        }

        onDoctorSelected?(doctors[index])
    }
}
