import Foundation

final class PatientRepositoryImpl: PatientRepository {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchPatient(id: String) async throws -> Patient {
        let request = GetPatientRequest(patientID: id)
        
        let response = try await networkClient.send(request)
        
        return response.toDomain()
    }
}

final class MockPatientRepository: PatientRepository {

    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchPatient(id: String) async throws -> Patient {
        Patient(
            id: "P001",
            firstName: "Rahul",
            lastName: "Sharma",
            dateOfBirth: "15 May 1990",
            phoneNumber: "+91 98765 43210",
            email: "rahul.sharma@example.com"
        )
    }
}
