import XCTest

@testable import HealthcarePro

@MainActor
final class PatientViewModelTests: XCTestCase {

    private var mockRepository: MockPatientRepository!
    private var getPatientUseCase: GetPatientUseCase!
    private var sut: PatientViewModel!

    override func setUp() {
        super.setUp()

        mockRepository = MockPatientRepository()

        getPatientUseCase = GetPatientUseCaseImpl(patientRepository: mockRepository)

        sut = PatientViewModel(getPatientUseCase: getPatientUseCase)
    }

    override func tearDown() {
        sut = nil
        getPatientUseCase = nil
        mockRepository = nil

        super.tearDown()
    }

    // MARK: - Success

    func test_fetchPatient_withValidPatient_setsPatient() async {

        mockRepository.patient = makePatient()

        sut.fetchPatient(patientId: "P001")

        await waitForPatientTask()

        XCTAssertEqual(
            mockRepository.fetchPatientCallCount,
            1
        )

        XCTAssertEqual(
            mockRepository.receivedPatientID,
            "P001"
        )

        XCTAssertNotNil(sut.patient)

        XCTAssertEqual(
            sut.patient?.id,
            "P001"
        )

        XCTAssertEqual(
            sut.patient?.firstName,
            "Rahul"
        )

        XCTAssertEqual(
            sut.patient?.lastName,
            "Sharma"
        )

        XCTAssertNil(sut.error)
    }

    // MARK: - Failure

    func test_fetchPatient_whenRepositoryFails_setsError() async {

        mockRepository.fetchError = NetworkError.notFound

        sut.fetchPatient(
            patientId: "P001"
        )

        await waitForPatientTask()

        XCTAssertEqual(
            mockRepository.fetchPatientCallCount,
            1
        )

        XCTAssertNil(sut.patient)

        XCTAssertNotNil(sut.error)
    }

    // MARK: - State Change

    func test_fetchPatient_notifiesStateChange() async {

        var stateChangeCallCount = 0

        mockRepository.patient = makePatient()

        sut.onStateChange = {
            stateChangeCallCount += 1
        }

        sut.fetchPatient(
            patientId: "P001"
        )

        await waitForPatientTask()

        XCTAssertGreaterThan(
            stateChangeCallCount,
            0
        )
    }

    // MARK: - Loading

    func test_fetchPatient_finishesWithLoadingFalse() async {

        mockRepository.patient = makePatient()

        sut.fetchPatient(
            patientId: "P001"
        )

        await waitForPatientTask()

        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Helpers

    private func makePatient() -> Patient {
        Patient(
            id: "P001",
            firstName: "Rahul",
            lastName: "Sharma",
            dateOfBirth: "1990-05-15",
            phoneNumber: "+919876543210",
            email: "rahul@example.com"
        )
    }

    private func waitForPatientTask() async {

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
