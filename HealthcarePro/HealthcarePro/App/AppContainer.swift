import UIKit

final class AppContainer {
    let appRouter: AppRouter
    let networkConfiguration: NetworkConfiguration
    let apiClient: APIClient
    
    init() {
        let networkConfiguration = NetworkConfiguration()
        self.networkConfiguration = networkConfiguration

        self.apiClient = URLSessionAPIClient(baseURL: networkConfiguration.serverBaseURL)
        
        self.appRouter =  AppRouter()
    }
}
