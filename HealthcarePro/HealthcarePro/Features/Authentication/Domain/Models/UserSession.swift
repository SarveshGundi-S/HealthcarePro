import Foundation

struct UserSession: Sendable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let user: User
}

struct User: Sendable {
    let id: String
    let name: String
    let role: String
}
