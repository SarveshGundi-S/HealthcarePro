import Foundation

protocol NetworkLogger: Sendable {
    func log(request: URLRequest)
    func log(response: HTTPURLResponse)
}
