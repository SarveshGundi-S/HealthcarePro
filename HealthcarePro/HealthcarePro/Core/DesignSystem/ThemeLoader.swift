import Foundation

protocol ThemeLoader: Sendable {

    func loadTheme() throws -> ThemeConfiguration
}

enum ThemeError: Error, Sendable {
    case fileNotFound
    case decodingFailed
}

final class BundleThemeLoader: ThemeLoader {

    private let bundle: Bundle
    private let fileName: String

    init(
        bundle: Bundle = .main,
        fileName: String = "ThemePallete"
    ) {
        self.bundle = bundle
        self.fileName = fileName
    }

    func loadTheme() throws -> ThemeConfiguration {

        guard let url = bundle.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            throw ThemeError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        do {
            return try JSONDecoder().decode(
                ThemeConfiguration.self,
                from: data
            )
        } catch {
            throw ThemeError.decodingFailed
        }
    }
}
