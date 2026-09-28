import Foundation

@MainActor
final class LaunchViewModel {
    private let checkAuthenticationUseCase: CheckAuthenticationUseCase

    var onDestinationSelected: ((LaunchDestination) -> Void)?
    
    init(checkAuthenticationUseCase: CheckAuthenticationUseCase) {
        self.checkAuthenticationUseCase = checkAuthenticationUseCase
    }

    func start() {
        Task {
            let isAuthenticated = await checkAuthenticationUseCase.execute()
            
            if isAuthenticated{
                onDestinationSelected?(.patient)
            } else {
                onDestinationSelected?(.login)
            }
        }
    }
}
