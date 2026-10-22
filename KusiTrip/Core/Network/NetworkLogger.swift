import Foundation
import Alamofire

/// Alamofire `EventMonitor` that prints every HTTP exchange to the Xcode
/// console: method, URL, headers and body of the request, then status code,
/// duration, headers and body of the response.
///
/// Each URLSession task is logged, so a 401 followed by the token refresh and
/// the retried request shows up as separate entries. Secrets (Authorization
/// header, passwords, tokens) are masked.
///
/// Uses `print` rather than `os.Logger`: unified logging truncates messages
/// at about 1 KB, which cuts most JSON bodies. Stdout is only shown when the
/// app runs from Xcode; on a user's device it is discarded.
nonisolated final class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.rapser.kusitrip.network-logger", qos: .utility)

    private let maxBodyLength = 10_000

    private static let redactedHeaders: Set<String> = ["authorization", "cookie", "set-cookie"]
    private static let redactedBodyKeys: Set<String> = ["password", "accessToken", "refreshToken"]
    private static let mask = "•••"

    // MARK: - EventMonitor

    func request(_ request: Request, didCreateTask task: URLSessionTask) {
        guard let urlRequest = task.originalRequest else { return }
        let method = urlRequest.httpMethod ?? "?"
        let url = urlRequest.url?.absoluteString ?? "?"

        var lines = ["⬆️ REQUEST  \(method) \(url)"]
        lines += headerLines(urlRequest.allHTTPHeaderFields ?? [:])
        lines += bodyLines(urlRequest.httpBody)
        log(lines)
    }

    func request(_ request: Request, didCompleteTask task: URLSessionTask, with error: AFError?) {
        let method = task.originalRequest?.httpMethod ?? "?"
        let url = task.originalRequest?.url?.absoluteString ?? "?"
        let duration = request.metrics.map { " · \(Int($0.taskInterval.duration * 1_000)) ms" } ?? ""

        guard let response = task.response as? HTTPURLResponse else {
            let reason = error?.underlyingError?.localizedDescription ?? error?.localizedDescription ?? "Sin respuesta"
            log(["❌ RESPONSE \(method) \(url)\(duration)", "Error: \(reason)"])
            return
        }

        let status = response.statusCode
        let isSuccess = (200..<300).contains(status)
        let statusText = isSuccess ? "" : " \(HTTPURLResponse.localizedString(forStatusCode: status).capitalized)"

        // Response headers are mostly Render/Cloudflare noise; only the content type helps.
        var lines = ["\(isSuccess ? "✅" : "❌") RESPONSE \(status)\(statusText) · \(method) \(url)\(duration)"]
        if let contentType = response.value(forHTTPHeaderField: "Content-Type") {
            lines.append("Content-Type: \(contentType)")
        }
        lines += bodyLines((request as? DataRequest)?.data)
        log(lines)
    }

    // MARK: - Formatting

    private func log(_ lines: [String]) {
        let separator = String(repeating: "─", count: 60)
        let message = ([separator] + lines + [separator]).joined(separator: "\n")
        print(message)
    }

    private func headerLines(_ headers: [String: String]) -> [String] {
        guard !headers.isEmpty else { return [] }
        let sorted = headers.sorted { $0.key.lowercased() < $1.key.lowercased() }
        return ["Headers:"] + sorted.map { name, value in
            let shown = Self.redactedHeaders.contains(name.lowercased()) ? Self.mask : value
            return "  \(name): \(shown)"
        }
    }

    private func bodyLines(_ data: Data?) -> [String] {
        guard let data, !data.isEmpty else { return [] }
        var body = prettyJSON(data) ?? String(decoding: data, as: UTF8.self)
        if body.count > maxBodyLength {
            body = String(body.prefix(maxBodyLength)) + "\n… (\(data.count) bytes en total, cuerpo recortado)"
        }
        return ["Body:", body]
    }

    private func prettyJSON(_ data: Data) -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]),
            let pretty = try? JSONSerialization.data(
                withJSONObject: redacted(object),
                options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes, .fragmentsAllowed]
            )
        else { return nil }
        return String(decoding: pretty, as: UTF8.self)
    }

    private func redacted(_ object: Any) -> Any {
        if let dictionary = object as? [String: Any] {
            return dictionary.reduce(into: [String: Any]()) { result, entry in
                result[entry.key] = Self.redactedBodyKeys.contains(entry.key) ? Self.mask : redacted(entry.value)
            }
        }
        if let array = object as? [Any] {
            return array.map(redacted)
        }
        return object
    }
}

extension Session {
    /// Session used for every call to the API: request timeout plus the
    /// network logger.
    nonisolated static func kusi(configuration: APIConfiguration) -> Session {
        let urlConfiguration = URLSessionConfiguration.af.default
        urlConfiguration.timeoutIntervalForRequest = configuration.timeout
        return Session(configuration: urlConfiguration, eventMonitors: [NetworkLogger()])
    }
}
