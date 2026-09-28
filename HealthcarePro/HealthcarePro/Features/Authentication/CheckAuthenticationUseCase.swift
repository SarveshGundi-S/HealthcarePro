import Foundation

protocol CheckAuthenticationUseCase {
    func execute() async -> Bool
}

final class CheckAuthenticationUseCaseImpl: CheckAuthenticationUseCase {
    private let tokenProvider: TokenProvider
    
    init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func execute() async -> Bool {
        await tokenProvider.accessToken() != nil
    }
}
