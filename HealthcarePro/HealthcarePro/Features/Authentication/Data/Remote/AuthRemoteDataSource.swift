import Foundation

protocol AuthRemoteDataSource {

    func login(username: String,
               password: String) async throws -> AuthResponseDTO
}
