import Foundation
@testable import HealthcarePro

final class MockAuthRepository: AuthRepository, @unchecked Sendable {

    var loginCallCount = 0
    var receivedEmail: String?
    var receivedPassword: String?

    var loginError: Error?

    func login(email: String, password: String) async throws {
        loginCallCount += 1
        receivedEmail = email
        receivedPassword = password

        if let loginError {
            throw loginError
        }
    }
}
