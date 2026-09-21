import Foundation

enum NetworkError: Error, Sendable {
    case invalidURL
    case transport(URLError)
    case invalidResponse

    case unauthorized
    case forbidden
    case notFound
    case conflict
    case serverError
    case unexpectedStatusCode(Int)

    case decoding
    case encoding
}
