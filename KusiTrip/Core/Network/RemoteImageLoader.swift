import ImageIO
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
        memoryCache.totalCostLimit = 250 * 1024 * 1024
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
            let image = try await Task.detached(priority: .userInitiated) {
                try Self.downsample(data)
            }.value
            let cost = Int(image.size.width * image.size.height * image.scale * image.scale * 4)
            memoryCache.setObject(image, forKey: url as NSURL, cost: cost)
            return image
        }
        inFlight[url] = download
        return try await download.value
    }

    /// Shortest side kept, in pixels. The catalog photos are wide banners
    /// (≈ 3:1) up to 7130 × 2431 px, about 70 MB once decoded. Cropped to fill a
    /// card or the hero, their height is what is visible, and 720 px covers the
    /// tallest card at 3x. Scaled down they take ~6 MB, so the whole Home fits
    /// in the memory cache and scrolling stays smooth.
    private nonisolated static let minPixelSide: CGFloat = 720

    /// Decodes straight to the reduced size with ImageIO, without ever holding
    /// the full-size bitmap in memory. Runs off the main thread.
    private nonisolated static func downsample(_ data: Data) throws -> UIImage {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let height = properties[kCGImagePropertyPixelHeight] as? CGFloat
        else {
            throw URLError(.cannotDecodeContentData)
        }
        // ImageIO limits the longest side; derive it from the shortest one.
        let scale = min(1, minPixelSide / min(width, height))
        let thumbnailOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: Int((max(width, height) * scale).rounded(.up)),
        ] as CFDictionary
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions) else {
            throw URLError(.cannotDecodeContentData)
        }
        return UIImage(cgImage: cgImage)
    }
}
