import Foundation

struct NetworkConfiguration {
    let serverBaseURL: URL
    let assetBaseURL: URL
    let apiVersion: String
    let platformID: String

    init(serverBaseURL: URL,
         assetBaseURL: URL,
         apiVersion: String,
         platformID: String) {
        self.serverBaseURL = serverBaseURL
        self.assetBaseURL = assetBaseURL
        self.apiVersion = apiVersion
        self.platformID = platformID
    }

    init(bundle: Bundle = .main) {
        guard let serverBaseURLString = bundle.object(forInfoDictionaryKey: "SERVER_BASE_URL") as? String,
              let serverBaseURL = URL(string: serverBaseURLString) else {
            fatalError("SERVER_BASE_URL is missing or invalid")
        }

        guard let assetBaseURLString = bundle.object(forInfoDictionaryKey: "ASSET_BASE_URL") as? String,
              let assetBaseURL = URL(string: assetBaseURLString) else {
            fatalError("ASSET_BASE_URL is missing or invalid")
        }

        guard let apiVersion = bundle.object(forInfoDictionaryKey: "API_VERSION") as? String,
              !apiVersion.isEmpty else {
            fatalError("API_VERSION is missing or invalid")
        }
        
        guard let platformID = bundle.object(forInfoDictionaryKey: "PLATFORM_ID") as? String,
              !platformID.isEmpty else {
            fatalError("PLATFORM_ID is missing or invalid")
        }
        
        self.init(serverBaseURL: serverBaseURL,
                  assetBaseURL: assetBaseURL,
                  apiVersion: apiVersion,
                  platformID: platformID)
    }
}
