import Foundation

final class APIClient: NetworkClient {
    
    private let session: URLSessionProtocol
    private let configuration: NetworkConfiguration
    private let tokenProvider: TokenProvider
    
    init(session: URLSessionProtocol, configuration: NetworkConfiguration, tokenProvider: TokenProvider) {
        self.session = session
        self.configuration = configuration
        self.tokenProvider = tokenProvider
    }

    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let urlRequest = try await makeURLRequest(from: request)

        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError {
            throw NetworkError.transport(error)
        }
        
        try validate(response)
        return try decode(Request.Response.self, from: data)
    }
}

private extension APIClient {
    func makeURLRequest<Request: APIRequest>( from request: Request) async throws -> URLRequest {
        let clientPath = request.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let endpointURL = configuration.baseURL.appendingPathComponent(configuration.apiVersion).appendingPathComponent(clientPath)
        
        var components = URLComponents(url: endpointURL, resolvingAgainstBaseURL: false)
        components?.queryItems = request.queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        // Common headers
        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        // Platform
        urlRequest.setValue(
            configuration.platformID,
            forHTTPHeaderField: "X-Platform-ID"
        )
        for (field, value) in request.headers {
            urlRequest.setValue(
                value,
                forHTTPHeaderField: field
            )
        }
        
        if let token = await tokenProvider.accessToken() {
            urlRequest.setValue("Bearer \(token)",
                                forHTTPHeaderField: "Authorization")
        }

        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encoding
            }
        }
        
        return urlRequest
    }

    private func decode<Response: Decodable & Sendable>(_ type: Response.Type,
                                             from data: Data) throws -> Response {

        if data.isEmpty {
            guard type == EmptyResponse.self else {
                throw NetworkError.decoding
            }

            return EmptyResponse() as! Response
        }

        do {
            return try JSONDecoder().decode(
                type,
                from: data
            )
        } catch {
            throw NetworkError.decoding
        }
    }
}

private extension APIClient {
    func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 409:
            throw NetworkError.conflict
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
}
