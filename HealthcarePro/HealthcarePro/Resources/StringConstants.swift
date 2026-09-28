import Foundation

struct StringConstants {

    struct Login {
        static let title = "login.title"
        static let email = "login.email"
        static let password = "login.password"
        static let button = "login.button"
        static let errorTitle = "login.error.title"
        static let invalidCredentials = "login.error.invalid_credentials"

        static let emailRequired = "login.error.email_required"
        static let invalidEmail = "login.error.invalid_email"
        static let passwordRequired = "login.error.password_required"
    }

    struct Launch {
        static let loading = "launch.loading"
    }

    struct Patient {
        static let title = "patient.title"
        static let dateOfBirth = "patient.date_of_birth"
        static let phone = "patient.phone"
        static let email = "patient.email"
        static let errorTitle = "patient.error.title"
    }

    struct Appointment {
        
        static let title = "appointment.title"
        static let doctor = "appointment.doctor"
        static let date = "appointment.date"
        static let bookButton = "appointment.book_button"
        
        static let successTitle = "appointment.success.title"
        static let errorTitle = "appointment.error.title"
        
        static let doctorRequired = "appointment.error.doctor_required"
        
        static let invalidDate =
        "appointment.error.invalid_date"
        
        static let bookAppointment = "appointment.bookAppointment"
        static let viewAppointments = "appointment.viewAppointments"
    }

    struct Common {
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
}
