import Foundation

enum LoginValidationError: LocalizedError,Sendable {
    case emailRequired
    case invalidEmail
    case passwordRequired
}

final class LoginViewModel {
    private let loginUseCase: LoginUseCase
    private let emailValidator: EmailValidator

    private(set) var isLoading = false
    private(set) var error: Error?

    var onStateChange: (() -> Void)?

    var onLoginSuccess: (() -> Void)?
    
    init(loginUseCase: LoginUseCase,
         emailValidator: EmailValidator = EmailValidator()) {
        self.emailValidator = emailValidator
        self.loginUseCase = loginUseCase
    }

    func login(email: String, password: String) {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !email.isEmpty else {
            showValidationError(.emailRequired)
            return
        }

        guard emailValidator.isValid(email) else {
            showValidationError(.invalidEmail)
            return
        }

        guard !password.isEmpty else {
            showValidationError(.passwordRequired)
            return
        }

        isLoading = true
        error = nil
        onStateChange?()
        
        Task {
            do {
                try await loginUseCase.execute(email: email, password: password)
                isLoading = false
                onStateChange?()
                onLoginSuccess?()
            } catch {
                self.error = error
                isLoading = false
                onStateChange?()
            }
        }
    
    }

    private func showValidationError(_ validationError: LoginValidationError) {
        error = validationError
        onStateChange?()
    }
}
