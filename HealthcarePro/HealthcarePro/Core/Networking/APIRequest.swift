import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    associatedtype Body: Encodable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Body? { get }
}
