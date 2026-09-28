import Foundation

struct APIErrorResponse: Decodable, Sendable {
    let code: String
    let message: String
}

enum Common {
    static let error = "common.error"
    static let ok = "common.ok"
    static let sessionExpired = "common.sessionExpired"
    static let noPermission = "common.noPermission"
    static let noAppointments = "common.noAppointments"
    static let serverError = "common.serverError"
    static let networkError = "common.networkError"
    static let unableToLoadAppointments = "common.unableToLoadAppointments"
    static let somethingWentWrong = "common.somethingWentWrong"
}
