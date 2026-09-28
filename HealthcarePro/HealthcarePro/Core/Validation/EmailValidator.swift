import Foundation

struct EmailValidator: Sendable {

    nonisolated func isValid(_ email: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedEmail.isEmpty else {
            return false
        }

        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        return trimmedEmail.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }
}
