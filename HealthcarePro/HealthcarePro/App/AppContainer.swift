import UIKit

final class AppContainer {
    let appRouter: AppRouter
    let networkConfiguration: NetworkConfiguration
    let apiClient: APIClient

    let patientRepository: PatientRepository
    let getPatientUseCase: GetPatientUseCase
    let tokenProvider: TokenProvider
    let authRespository: AuthRepository
    let loginUseCase: LoginUseCase
    let checkAuthenticationUseCase: CheckAuthenticationUseCase
    let appointmentRepository: AppointmentRepository
    let bookAppointmentUseCase: BookAppointmentUseCase
    let doctorRepository: DoctorRepository
    let getDoctorsUseCase: GetDoctorsUseCase
    let getAppointmentsUseCase:
        GetAppointmentsUseCase
    
    init() {

        let themeLoader = BundleThemeLoader()
        
        do {
            let themeConfiguration = try themeLoader.loadTheme()
            
            AppColor.configure(with: themeConfiguration.colors)
            AppFont.configure(with: themeConfiguration.typography)
            AppSpacing.configure(with: themeConfiguration.spacing)
        } catch {
            fatalError("Failed to load app theme: \(error)")
        }
        
        let networkConfiguration = NetworkConfiguration()
        self.networkConfiguration = networkConfiguration

        let keychain = KeychainServiceImpl()

        let tokenProvider = KeychainTokenProvider(
            keychain: keychain
        )
        self.tokenProvider = tokenProvider

        let sessionConfiguration =
            URLSessionConfiguration.default

        sessionConfiguration.timeoutIntervalForRequest = 30
        sessionConfiguration.timeoutIntervalForResource = 60
        sessionConfiguration.waitsForConnectivity = true

        let session = URLSession(
            configuration: sessionConfiguration
        )

        let apiClient = APIClient(session: session,
                                   configuration: networkConfiguration,
                                   tokenProvider: tokenProvider)
        self.apiClient = apiClient
        
        let authRespository = AuthRepositoryImpl(networkClient: apiClient, tokenProvider: tokenProvider)
        self.authRespository = authRespository

        let loginUseCase = LoginUseCaseImpl(authRespository: authRespository)
        self.loginUseCase = loginUseCase

        
        let patientRepository = PatientRepositoryImpl(networkClient: apiClient)
        self.patientRepository = patientRepository

        let getPatientUseCase = GetPatientUseCaseImpl(patientRepository: patientRepository)
        self.getPatientUseCase = getPatientUseCase

        let checkAuthenticationUseCase = CheckAuthenticationUseCaseImpl(tokenProvider: tokenProvider)
        self.checkAuthenticationUseCase = checkAuthenticationUseCase
        
        let appointmentRepository = AppointmentRepositoryImpl(networkClient: apiClient)
        self.appointmentRepository = appointmentRepository

        let bookAppointmentUseCase = BookAppointmentUseCaseImpl(appointmentRepository: appointmentRepository)
        self.bookAppointmentUseCase = bookAppointmentUseCase

        let doctorRepository = DoctorRepositoryImpl(networkClient: apiClient)
        self.doctorRepository = doctorRepository

        let getDoctorsUseCase = GetDoctorsUseCaseImpl(doctorRepository: doctorRepository)
        self.getDoctorsUseCase = getDoctorsUseCase

        let getAppointmentsUseCase = GetAppointmentsUseCaseImpl(appointmentRepository: appointmentRepository)
        self.getAppointmentsUseCase = getAppointmentsUseCase
        
        self.appRouter =  AppRouter(getPatientUseCase: getPatientUseCase,
                                    loginUseCase: loginUseCase,
                                    checkAuthenticationUseCase: checkAuthenticationUseCase,
                                    bookAppointmentUseCase: bookAppointmentUseCase,
                                    getDoctorsUseCase: getDoctorsUseCase,
                                    getAppointmentsUseCase: getAppointmentsUseCase)
    }
}
