import Foundation

protocol APIClient {
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}
