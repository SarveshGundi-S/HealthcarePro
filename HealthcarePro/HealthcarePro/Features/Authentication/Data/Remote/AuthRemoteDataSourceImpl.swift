import Foundation

class AuthRemoteDataSourceImpl: AuthRepository {

    private let remoteDataSource: AuthRemoteDataSource

    init(remoteDataSource: AuthRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func login(username: String, password: String) async throws -> UserSession {
        let response = try await remoteDataSource.login(username: username,
                                                        password: password)
        return UserSession(accessToken: response.accessToken,
                           refreshToken: response.refreshToken,
                           expiresIn: response.expiresIn,
                           user: User(id: response.user.id,
                                      name: response.user.name,
                                      role: response.user.role))
    }
}
