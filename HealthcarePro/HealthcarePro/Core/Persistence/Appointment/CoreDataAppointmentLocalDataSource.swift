import CoreData

final class CoreDataAppointmentLocalDataSource:
    AppointmentLocalDataSource {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func save(
        _ appointments: [Appointment]
    ) async throws {

        let context = coreDataStack.viewContext

        for appointment in appointments {

            let request = AppointmentEntity.fetchRequest()

            request.predicate = NSPredicate(
                format: "id == %@",
                appointment.id
            )

            request.fetchLimit = 1

            let entity: AppointmentEntity

            if let existingEntity = try context.fetch(request).first {
                entity = existingEntity
            } else {
                entity = AppointmentEntity(
                    context: context
                )
            }

            entity.id = appointment.id
            entity.patientId = appointment.patientId
            entity.doctorId = appointment.doctorId
            entity.appointmentDate = appointment.appointmentDate
            entity.status = appointment.status
        }

        if context.hasChanges {
            try context.save()
        }
    }

    func fetchAppointments(
        patientID: String
    ) async throws -> [Appointment] {

        let context = coreDataStack.viewContext

        let request = AppointmentEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "patientId == %@",
            patientID
        )

        let entities = try context.fetch(request)

        return entities.compactMap {
            $0.toDomain()
        }
    }
}
