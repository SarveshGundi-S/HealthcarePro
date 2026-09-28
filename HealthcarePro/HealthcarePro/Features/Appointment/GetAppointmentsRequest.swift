import Foundation

struct GetAppointmentsRequest: APIRequest {
    typealias Response = [AppointmentResponse]
    typealias Body = EmptyBody
    
    let patientId: String
    
    var body: EmptyBody? {
        nil
    }
    
    var path: String {
        "/appointments"
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "patientId", value: patientId)]
    }
    
}
