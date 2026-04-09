import Foundation

actor EventBus {
    static let shared = EventBus()
    private var subscribers: [UUID: AsyncStream<AppEvent>.Continuation] = [:]

    private init() {}

    /// Registers a new subscriber and returns an `AsyncStream` that emits `AppEvent`s.
    /// Uses `AsyncStream.makeStream(of:)` (Swift 5.9+) so the continuation is stored
    /// directly inside the actor-isolated method body — no inner `Task { await }` needed.
    func subscribe() -> AsyncStream<AppEvent> {
        let id = UUID()
        let (stream, continuation) = AsyncStream.makeStream(of: AppEvent.self)
        subscribers[id] = continuation
        // `onTermination` runs in a non-isolated context, so the Task here is
        // non-isolated and the actor hop for `removeSubscriber` is a genuine async op.
        continuation.onTermination = { [id] _ in
            Task { [id] in
                await EventBus.shared.removeSubscriber(id: id)
            }
        }
        return stream
    }

    private func removeSubscriber(id: UUID) {
        subscribers.removeValue(forKey: id)
    }

    func send(_ event: AppEvent) {
        for continuation in subscribers.values {
            continuation.yield(event)
        }
    }
}
