import Foundation

protocol TokenProvider: Sendable {
    func accessToken() async -> String?
    func saveAccessToken(_ token: String) async throws
    func clearAccessToken() async throws
}

final class KeychainTokenProvider: TokenProvider {
    private let keychain: KeychainService
    
    init(keychain: KeychainService) {
        self.keychain = keychain
    }

    func accessToken() async -> String? {
        do {
            return try keychain.read(for: KeychainKey.accessToken)
        } catch {
            return nil
        }
    }

    func saveAccessToken(_ token: String) async throws {
        try keychain.save(token, for: KeychainKey.accessToken)
    }

    func clearAccessToken() async throws {
        try keychain.delete(for: KeychainKey.accessToken)
    }
}
