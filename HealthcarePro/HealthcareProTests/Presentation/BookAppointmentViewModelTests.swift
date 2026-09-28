import XCTest

@testable import HealthcarePro

@MainActor
final class BookAppointmentViewModelTests: XCTestCase {

    private var mockRepository: MockAppointmentRepository!
    private var bookAppointmentUseCase: BookAppointmentUseCase!
    private var sut: BookAppointmentViewModel!

    private let patientId = "P001"

    override func setUp() {
        super.setUp()

        mockRepository = MockAppointmentRepository()

        bookAppointmentUseCase = BookAppointmentUseCaseImpl(
            appointmentRepository: mockRepository
        )

        sut = BookAppointmentViewModel(
            patientId: patientId,
            bookAppointmentUseCase: bookAppointmentUseCase
        )
    }

    override func tearDown() {
        sut = nil
        bookAppointmentUseCase = nil
        mockRepository = nil

        super.tearDown()
    }

    // MARK: - Validation

    func test_bookAppointment_withoutDoctor_doesNotCallRepository() {

        sut.bookAppointment(
            appointmentDate: futureDate()
        )

        XCTAssertEqual(
            mockRepository.bookAppointmentCallCount,
            0
        )

        XCTAssertNotNil(sut.error)
    }

    // MARK: - Success

    func test_bookAppointment_withValidDetails_callsRepository() async {

        let doctor = makeDoctor()
        let appointment = makeAppointment(
            doctorId: doctor.id
        )

        mockRepository.appointment = appointment

        sut.selectDoctor(doctor)

        sut.bookAppointment(
            appointmentDate: futureDate()
        )

        await waitForBookingTask()

        XCTAssertEqual(
            mockRepository.bookAppointmentCallCount,
            1
        )

        XCTAssertEqual(
            mockRepository.receivedPatientID,
            patientId
        )

        XCTAssertEqual(
            mockRepository.receivedDoctorID,
            doctor.id
        )

        XCTAssertNotNil(
            mockRepository.receivedAppointmentDate
        )
    }

    func test_bookAppointment_withValidDetails_setsAppointment() async {

        let doctor = makeDoctor()
        let appointment = makeAppointment(
            doctorId: doctor.id
        )

        mockRepository.appointment = appointment

        sut.selectDoctor(doctor)

        sut.bookAppointment(
            appointmentDate: futureDate()
        )

        await waitForBookingTask()

        XCTAssertNotNil(sut.appointment)

        XCTAssertEqual(
            sut.appointment?.id,
            appointment.id
        )

        XCTAssertEqual(
            sut.appointment?.patientId,
            patientId
        )

        XCTAssertEqual(
            sut.appointment?.doctorId,
            doctor.id
        )

        XCTAssertNil(sut.error)
    }

    // MARK: - Failure

    func test_bookAppointment_whenRepositoryFails_setsError() async {

        let doctor = makeDoctor()

        mockRepository.bookAppointmentError = NetworkError.serverError

        sut.selectDoctor(doctor)

        sut.bookAppointment(
            appointmentDate: futureDate()
        )

        await waitForBookingTask()

        XCTAssertEqual(
            mockRepository.bookAppointmentCallCount,
            1
        )

        XCTAssertNil(sut.appointment)

        XCTAssertNotNil(sut.error)
    }

    // MARK: - Success Callback

    func test_bookAppointment_whenSuccessful_callsBookingSuccess() async {

        let doctor = makeDoctor()
        let appointment = makeAppointment(
            doctorId: doctor.id
        )

        mockRepository.appointment = appointment

        var receivedAppointment: Appointment?

        sut.onBookingSuccess = { appointment in
            receivedAppointment = appointment
        }

        sut.selectDoctor(doctor)

        sut.bookAppointment(
            appointmentDate: futureDate()
        )

        await waitForBookingTask()

        XCTAssertNotNil(receivedAppointment)

        XCTAssertEqual(
            receivedAppointment?.id,
            appointment.id
        )
    }

    // MARK: - State Change

    func test_bookAppointment_notifiesStateChange() async {

        let doctor = makeDoctor()
        let appointment = makeAppointment(
            doctorId: doctor.id
        )

        mockRepository.appointment = appointment

        var stateChangeCallCount = 0

        sut.onStateChange = {
            stateChangeCallCount += 1
        }

        sut.selectDoctor(doctor)

        sut.bookAppointment(
            appointmentDate: futureDate()
        )

        await waitForBookingTask()

        XCTAssertGreaterThan(
            stateChangeCallCount,
            0
        )
    }

    // MARK: - Loading

    func test_bookAppointment_finishesWithLoadingFalse() async {

        let doctor = makeDoctor()
        let appointment = makeAppointment(
            doctorId: doctor.id
        )

        mockRepository.appointment = appointment

        sut.selectDoctor(doctor)

        sut.bookAppointment(
            appointmentDate: futureDate()
        )

        await waitForBookingTask()

        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Helpers

    private func makeDoctor() -> Doctor {
        Doctor(
            id: "D001",
            firstName: "Amit",
            lastName: "Patel",
            specialization: "Cardiology"
        )
    }

    private func makeAppointment(
        doctorId: String
    ) -> Appointment {
        Appointment(
            id: "A001",
            patientId: patientId,
            doctorId: doctorId,
            appointmentDate: "2026-10-15T10:30:00Z",
            status: "confirmed"
        )
    }

    private func futureDate() -> Date {
        Date().addingTimeInterval(3600)
    }

    private func waitForBookingTask() async {

        for _ in 0..<20 {

            if !sut.isLoading {
                return
            }

            try? await Task.sleep(
                nanoseconds: 10_000_000
            )
        }
    }
}
