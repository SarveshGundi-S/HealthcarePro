protocol AppointmentLocalDataSource: Sendable {

    func save(_ appointments: [Appointment]) async throws

    func fetchAppointments(patientID: String) async throws -> [Appointment]
}
