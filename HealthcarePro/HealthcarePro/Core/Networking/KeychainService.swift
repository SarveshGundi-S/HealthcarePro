import Foundation

protocol KeychainService: Sendable {

    func save(
        _ value: String,
        for key: String
    ) throws

    func read(
        for key: String
    ) throws -> String?

    func delete(
        for key: String
    ) throws
}

enum KeychainKey {
    static let accessToken = "healthcarepro.accessToken"
    static let refreshToken = "healthcarepro.refreshToken"
}

enum KeychainError: Error, Sendable {
    case unableToSave(OSStatus)
    case unableToRead(OSStatus)
    case unableToDelete(OSStatus)
    case invalidData
}

final class KeychainServiceImpl: KeychainService {
    func save(_ value: String, for key: String) throws {
        let data = value.utf8
        
        let query: [ String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave(status)
        }
    }
    
    func read(for key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary,
                                         &result)
        if status == errSecItemNotFound {
            return nil
        }

        guard let data = result as? Data else {
            throw KeychainError.invalidData
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete(status)
        }
    }
    
    
}
