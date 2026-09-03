import Foundation

struct LoginRequest: @MainActor APIRequest {
    
    typealias Response = AuthResponseDTO
    typealias Body = LoginRequestBody

    struct LoginRequestBody: Encodable {
        let username: String
        let password: String
    }
    
    let path: String = NetworkTypes.LOGIN_URL
    
    let method: HTTPMethod = .POST
    
    let headers: [String : String] = ["Content-Type": "application/json"]
    
    let body: LoginRequestBody?
    
    init(username: String,
         password: String) {
        self.body = LoginRequestBody(username: username, password: password)
    }
    
    
}
