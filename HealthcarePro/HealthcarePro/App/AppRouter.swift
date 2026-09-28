import UIKit

final class AppRouter {
    let navigationController: UINavigationController

    private let getPatientUseCase: GetPatientUseCase
    private let loginUseCase: LoginUseCase
    private let checkAuthenticationUseCase: CheckAuthenticationUseCase
    private let bookAppointmentUseCase: BookAppointmentUseCase
    private let getDoctorsUseCase: GetDoctorsUseCase
    private let getAppointmentsUseCase: GetAppointmentsUseCase
    
    init(getPatientUseCase: GetPatientUseCase,
         loginUseCase: LoginUseCase,
         checkAuthenticationUseCase: CheckAuthenticationUseCase,
         bookAppointmentUseCase: BookAppointmentUseCase,
         getDoctorsUseCase: GetDoctorsUseCase,
         getAppointmentsUseCase: GetAppointmentsUseCase) {
        self.getPatientUseCase = getPatientUseCase
        self.loginUseCase = loginUseCase
        self.checkAuthenticationUseCase = checkAuthenticationUseCase
        self.bookAppointmentUseCase = bookAppointmentUseCase
        self.getDoctorsUseCase = getDoctorsUseCase
        self.getAppointmentsUseCase = getAppointmentsUseCase

        self.navigationController = UINavigationController()
    }

    func Start() {
        let viewModel = LaunchViewModel(checkAuthenticationUseCase: checkAuthenticationUseCase)

        let viewController = LaunchViewController(viewModel: viewModel)

        viewModel.onDestinationSelected = { [weak self] destination in
            switch destination {
            case .login:
                self?.showLogin()
            case .patient:
                self?.showPatient()
            }
        }
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showPatient() {
        let viewModel = PatientViewModel(getPatientUseCase: getPatientUseCase)

        let viewController = PatientViewController(viewModel: viewModel)

        viewController.onBookAppointment = { [weak self] in

            guard let patientId = viewModel.patient?.id else {
                return
            }
            self?.showBookAppointment(patientId: patientId)
        }

        viewController.onViewAppointments = { [weak self] in
            guard let patientId = viewModel.patient?.id else {
                return
            }
            self?.showAppointments(patientId: patientId)
        }

        navigationController.pushViewController(viewController, animated: true)

        viewModel.fetchPatient(patientId: "P001")
    }

    func showLogin() {
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)

        let viewController = LoginViewController(viewModel: viewModel)

        viewModel.onLoginSuccess = { [weak self] in
            self?.showLogin()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    func showBookAppointment(patientId: String) {
        let viewModel = BookAppointmentViewModel(patientId: patientId,
                                                 bookAppointmentUseCase: bookAppointmentUseCase)
        
        let viewController = BookAppointmentViewController(viewModel: viewModel)

        viewController.onSelectDoctor = { [weak self] in
            self?.showDoctorSelection { doctor in
                viewModel.selectDoctor(doctor)
            }
        }

        viewController.onBookingSuccess = { [weak self] appointment in
            self?.showAppointmentConfirmation(appointment: appointment)
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDoctorSelection(_ onSelected: @escaping (Doctor) -> Void) {
        let viewModel = DoctorSelectionViewModel(getDoctorsUseCase: getDoctorsUseCase)
        
        let viewController = DoctorSelectionViewController(viewModel: viewModel)

        viewModel.onDoctorSelected = { [weak self] doctor in
            self?.navigationController.popViewController(animated: true)
            onSelected(doctor)
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    func showAppointmentConfirmation(appointment: Appointment) {

        let viewController =
            AppointmentConfirmationViewController(
                appointment: appointment
            )

        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }

    func showAppointments(patientId: String) {
        let viewModel = AppointmentListViewModel(patientId: patientId,
                                                 getAppointmentsUseCase: getAppointmentsUseCase)
        
        let viewController = AppointmentListViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
