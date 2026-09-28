import Foundation

protocol LoginUseCase {
    func execute(email: String, password: String) async throws 
}

final class LoginUseCaseImpl: LoginUseCase {
    private let authRespository: AuthRepository
    
    init(authRespository: AuthRepository) {
        self.authRespository = authRespository
    }

    func execute(email: String, password: String) async throws {
        try await authRespository.login(email: email, password: password)
    }
}
