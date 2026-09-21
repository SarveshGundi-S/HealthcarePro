import Foundation

protocol NetworkClient: Sendable {
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}
