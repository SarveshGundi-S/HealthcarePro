import Foundation

struct GetDoctorsRequest: APIRequest {
    typealias Response = [DoctorResponse]
    typealias Body = EmptyBody
    
    var body: Body? {
        nil
    }
    
    var path: String {
        "/doctors"
    }
    
    var method: HTTPMethod {
        .GET
    }
}
