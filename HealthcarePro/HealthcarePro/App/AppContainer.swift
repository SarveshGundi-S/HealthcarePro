import UIKit

final class AppContainer {
    let appRouter: AppRouter
    let networkConfiguration: NetworkConfiguration
    let apiClient: APIClient
    
    init() {
        let networkConfiguration = NetworkConfiguration()
        self.networkConfiguration = networkConfiguration

        let keychain = KeychainServiceImpl()

        let tokenProvider = KeychainTokenProvider(
            keychain: keychain
        )
        let sessionConfiguration =
            URLSessionConfiguration.default

        sessionConfiguration.timeoutIntervalForRequest = 30
        sessionConfiguration.timeoutIntervalForResource = 60
        sessionConfiguration.waitsForConnectivity = true

        let session = URLSession(
            configuration: sessionConfiguration
        )


        self.apiClient = APIClient(session: session, configuration: networkConfiguration, tokenProvider: tokenProvider)
        self.appRouter =  AppRouter()
    }
}
