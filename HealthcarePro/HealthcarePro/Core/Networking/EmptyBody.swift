import Foundation

struct EmptyBody: Sendable {
}

nonisolated extension EmptyBody: Encodable {
}

struct EmptyResponse: Decodable, Sendable {}
