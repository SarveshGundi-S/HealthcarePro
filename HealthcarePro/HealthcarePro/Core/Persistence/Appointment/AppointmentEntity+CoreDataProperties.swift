import Foundation

import CoreData

extension AppointmentEntity {

    @nonobjc
    class func fetchRequest() -> NSFetchRequest<AppointmentEntity> {
        NSFetchRequest<AppointmentEntity>(
            entityName: "AppointmentEntity"
        )
    }

    @NSManaged
    var id: String?

    @NSManaged
    var patientId: String?

    @NSManaged
    var doctorId: String?

    @NSManaged
    var appointmentDate: String?

    @NSManaged
    var status: String?
}

extension AppointmentEntity {

    func toDomain() -> Appointment? {
        guard
            let id,
            let patientId,
            let doctorId,
            let appointmentDate,
            let status
        else {
            return nil
        }

        return Appointment(
            id: id,
            patientId: patientId,
            doctorId: doctorId,
            appointmentDate: appointmentDate,
            status: status
        )
    }
}
