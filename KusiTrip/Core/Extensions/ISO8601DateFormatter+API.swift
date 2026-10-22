import Foundation

extension ISO8601DateFormatter {
    /// Dates sent by the API, e.g. `2026-09-27T00:00:00.000Z`.
    nonisolated(unsafe) static let kusiAPI: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
