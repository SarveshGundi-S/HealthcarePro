import Foundation

struct LoginRequestBody: Sendable {
    let email: String
    let password: String
}
nonisolated extension LoginRequestBody: Encodable {}

struct LoginRequest: APIRequest {
    typealias Response = LoginResponse
    typealias Body = LoginRequestBody


    let body: LoginRequestBody?

    var path: String {
        "/auth/login"
    }

    var method: HTTPMethod {
        .POST
    }
}


