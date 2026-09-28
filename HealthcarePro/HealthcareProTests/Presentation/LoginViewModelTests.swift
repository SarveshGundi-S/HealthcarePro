import XCTest
@testable import HealthcarePro

@MainActor
final class LoginViewModelTests: XCTestCase {

    private var mockRepository: MockAuthRepository!
    private var loginUseCase: LoginUseCase!
    private var sut: LoginViewModel!

    override func setUp() {
        super.setUp()

        mockRepository = MockAuthRepository()
        loginUseCase = LoginUseCaseImpl(authRespository: mockRepository)

        sut = LoginViewModel(loginUseCase: loginUseCase)
    }

    override func tearDown() {
        sut = nil
        loginUseCase = nil
        mockRepository = nil

        super.tearDown()
    }

    // MARK: - Validation

    func test_login_withEmptyEmail_doesNotCallRepository() {
        sut.login(
            email: "",
            password: "Password123"
        )

        XCTAssertEqual(
            mockRepository.loginCallCount,
            0
        )

        XCTAssertNotNil(sut.error)
    }

    func test_login_withInvalidEmail_doesNotCallRepository() {
        sut.login(
            email: "invalid-email",
            password: "Password123"
        )

        XCTAssertEqual(
            mockRepository.loginCallCount,
            0
        )

        XCTAssertNotNil(sut.error)
    }

    func test_login_withEmptyPassword_doesNotCallRepository() {
        sut.login(
            email: "user@example.com",
            password: ""
        )

        XCTAssertEqual(
            mockRepository.loginCallCount,
            0
        )

        XCTAssertNotNil(sut.error)
    }

    // MARK: - Success

    func test_login_withValidCredentials_callsRepository() async {
        sut.login(
            email: "user@example.com",
            password: "Password123"
        )

        await waitForLoginTask()

        XCTAssertEqual(
            mockRepository.loginCallCount,
            1
        )

        XCTAssertEqual(
            mockRepository.receivedEmail,
            "user@example.com"
        )

        XCTAssertEqual(
            mockRepository.receivedPassword,
            "Password123"
        )

        XCTAssertNil(sut.error)
    }

    // MARK: - Failure

    func test_login_whenRepositoryFails_setsError() async {
        mockRepository.loginError = NetworkError.unauthorized

        sut.login(
            email: "user@example.com",
            password: "Password123"
        )

        await waitForLoginTask()

        XCTAssertEqual(
            mockRepository.loginCallCount,
            1
        )

        XCTAssertNotNil(sut.error)
    }

    // MARK: - State Change

    func test_login_notifiesStateChange() async {
        var stateChangeCallCount = 0

        sut.onStateChange = {
            stateChangeCallCount += 1
        }

        sut.login(
            email: "user@example.com",
            password: "Password123"
        )

        await waitForLoginTask()

        XCTAssertGreaterThan(
            stateChangeCallCount,
            0
        )
    }

    // MARK: - Helpers

    private func waitForLoginTask() async {
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
