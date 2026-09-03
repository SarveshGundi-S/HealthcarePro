import Foundation

enum NetworkError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
}
