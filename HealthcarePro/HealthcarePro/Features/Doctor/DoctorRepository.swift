import Foundation

protocol DoctorRepository: Sendable {
    func fetchDoctors() async throws -> [Doctor]
}

final class DoctorRepositoryImpl: DoctorRepository {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchDoctors() async throws -> [Doctor] {
        let reuquest = GetDoctorsRequest()
        
        let response = try await networkClient.send(reuquest)
        
        return response.map { $0.toDomain() }
    }
}
