import Foundation

protocol APIRequest: Sendable {
    associatedtype Response: Decodable & Sendable
    associatedtype Body: Encodable & Sendable = EmptyBody
    
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: Body? { get }
}
extension APIRequest {
    var headers: [String: String] {
        [:]
    }

    var queryItems: [URLQueryItem] {
        []
    }
}
