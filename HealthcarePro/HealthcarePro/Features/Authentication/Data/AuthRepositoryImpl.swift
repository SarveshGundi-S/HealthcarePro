import Foundation

final class AuthRepositoryImpl: AuthRepository {

    private let networkClient: NetworkClient
    private let tokenProvider: TokenProvider

    init(
        networkClient: NetworkClient,
        tokenProvider: TokenProvider
    ) {
        self.networkClient = networkClient
        self.tokenProvider = tokenProvider
    }

    func login(
        email: String,
        password: String
    ) async throws {

        let request = LoginRequest(body:.init(email: email,
                                              password: password))

        let response = try await networkClient.send(request)

        try await tokenProvider.saveAccessToken(
            response.accessToken
        )
    }
}
