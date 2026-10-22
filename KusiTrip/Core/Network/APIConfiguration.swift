import Foundation

nonisolated struct APIConfiguration: Sendable {
    let baseURL: URL
    /// Render's free tier can take 30-60s to wake up, so requests get a generous timeout.
    let timeout: TimeInterval

    static let `default` = APIConfiguration(
        baseURL: Bundle.main.apiBaseURL,
        timeout: 90
    )
}

private extension Bundle {
    /// `API_BASE_URL` is set per build configuration (Debug → localhost, Release → Render).
    nonisolated var apiBaseURL: URL {
        guard
            let value = object(forInfoDictionaryKey: "API_BASE_URL") as? String,
            let url = URL(string: value)
        else {
            fatalError("API_BASE_URL is missing from Info.plist")
        }
        return url
    }
}
