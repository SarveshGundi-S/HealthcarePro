import Foundation

import Foundation

final class URLSessionAPIClient: APIClient {
    
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(session: URLSession = .shared,
         baseURL: URL,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.baseURL = baseURL
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        
        let url = baseURL.appendingPathComponent(request.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        for (field, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }
        
        if let body = request.body {
            urlRequest.httpBody = try encoder.encode(body)
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(
                statusCode: httpResponse.statusCode
            )
        }
        
        return try JSONDecoder().decode(
            Request.Response.self,
            from: data
        )
    }
}
