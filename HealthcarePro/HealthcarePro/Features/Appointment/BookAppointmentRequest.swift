import Foundation

struct BookAppointmentRequest: APIRequest {
    typealias Response = AppointmentResponse
    typealias Body = BookAppointmentBody
    
    let body: BookAppointmentBody?
    
    var path: String {
        "/appointments"
    }
    
    var method: HTTPMethod {
        .POST
    }
}
