import Foundation

struct AuthResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let user: UserDTO
}

struct UserDTO: Decodable {
    let id: String
    let name: String
    let role: String
}

class NetworkTypes {
    static let loginRequestId = 100
    static let loginResponseId = 101

    static var LOGIN_URL = ""

    static var PLATFORM_ID = "1"
    static var API_VERSION = "api/V12/"
    static var SERVER_BASE_URL = "https://healthcarepro.com/"
    static var ASSET_BASE_URL = "https://healthcarepro.com/"

    static func initialize() {
        LOGIN_URL = "\(SERVER_BASE_URL)\(API_VERSION)auth/login"
    }
}
