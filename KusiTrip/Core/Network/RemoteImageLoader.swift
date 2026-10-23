import UIKit

/// Downloads the catalog photos once and keeps them:
/// - in memory (`NSCache`), so a photo already seen shows on the first frame;
/// - on disk (`URLCache`), so it survives relaunches. The default cache skips
///   responses over ~500 KB, and most catalog photos are bigger.
///
/// Concurrent requests for the same URL share one download, and that download
/// is not tied to any view: if the view that asked for it is redrawn or
/// disappears, the photo keeps downloading and the next view gets it.
final class RemoteImageLoader {
    static let shared = RemoteImageLoader()

    private let session: URLSession
    private let memoryCache = NSCache<NSURL, UIImage>()
    private var inFlight: [URL: Task<UIImage, Error>] = [:]

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 200 * 1024 * 1024)
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.timeoutIntervalForRequest = 30
        session = URLSession(configuration: configuration)
        memoryCache.totalCostLimit = 100 * 1024 * 1024
    }

    func cachedImage(for url: URL) -> UIImage? {
        memoryCache.object(forKey: url as NSURL)
    }

    func image(for url: URL) async throws -> UIImage {
        if let cached = cachedImage(for: url) { return cached }
        if let download = inFlight[url] { return try await download.value }

        let download = Task { [session, memoryCache] in
            defer { self.inFlight[url] = nil }
            let (data, response) = try await session.data(from: url)
            if let status = (response as? HTTPURLResponse)?.statusCode, !(200..<300).contains(status) {
                throw URLError(.badServerResponse)
            }
            guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
            // Decode now, off the main thread, so scrolling never stalls on it.
            let prepared = await image.byPreparingForDisplay() ?? image
            let cost = Int(prepared.size.width * prepared.size.height * prepared.scale * prepared.scale * 4)
            memoryCache.setObject(prepared, forKey: url as NSURL, cost: cost)
            return prepared
        }
        inFlight[url] = download
        return try await download.value
    }
}
