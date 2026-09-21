import Foundation

struct GetPatientRequest: APIRequest {    

    typealias Response = PatientResponse
    typealias Body = EmptyBody

    let patientID: String

    var path: String {
        "/patients/\(patientID)"
    }

    var method: HTTPMethod {
        .GET
    }

    var body: EmptyBody? {
        nil
    }
}
