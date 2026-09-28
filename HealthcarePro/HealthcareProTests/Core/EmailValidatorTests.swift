import XCTest
@testable import HealthcarePro

final class EmailValidatorTests: XCTestCase {

    func test_validEmail_returnsTrue() {
        let sut = EmailValidator()
        let email = "user@example.com"

        let result = sut.isValid(email)

        XCTAssertTrue(result)
    }

    func test_invalidEmail_returnsFalse() {
        let sut = EmailValidator()
        let email = "invalid-email"

        let result = sut.isValid(email)

        XCTAssertFalse(result)
    }

    func test_emptyEmail_returnsFalse() {
        let sut = EmailValidator()
        let email = ""

        let result = sut.isValid(email)

        XCTAssertFalse(result)
    }

    func test_emailWithLeadingAndTrailingSpaces_returnsTrue() {
        let sut = EmailValidator()
        let email = "  user@example.com  "

        let result = sut.isValid(email)

        XCTAssertTrue(result)
    }
}
