import Foundation

struct NetworkConfiguration: Sendable {
    let baseURL: URL
    let apiVersion: String
    let platformID: String

    init(baseURL: URL,
         apiVersion: String,
         platformID: String) {
        self.baseURL = baseURL
        self.apiVersion = apiVersion
        self.platformID = platformID
    }

    init(bundle: Bundle = .main) {
        guard let serverBaseURLString = bundle.object(forInfoDictionaryKey: "SERVER_BASE_URL") as? String,
              let serverBaseURL = URL(string: serverBaseURLString) else {
            fatalError("SERVER_BASE_URL is missing or invalid")
        }

        guard let apiVersion = bundle.object(forInfoDictionaryKey: "API_VERSION") as? String,
              !apiVersion.isEmpty else {
            fatalError("API_VERSION is missing or invalid")
        }
        
        guard let platformID = bundle.object(forInfoDictionaryKey: "PLATFORM_ID") as? String,
              !platformID.isEmpty else {
            fatalError("PLATFORM_ID is missing or invalid")
        }
        
        self.init(baseURL: serverBaseURL,
                  apiVersion: apiVersion,
                  platformID: platformID)
    }
}
