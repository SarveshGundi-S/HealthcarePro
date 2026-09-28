import Foundation

struct LoginResponse: Sendable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}
nonisolated extension LoginResponse: Decodable {}
